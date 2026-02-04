import Foundation
import RxSwift

@MainActor
final class PokemonListViewModel: ObservableObject {
    // Owns list state, pagination, and search filtering.
    @Published private(set) var items: [Pokemon] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil
    @Published var query: String = "" {
        didSet { applyFilterAndPagination(reset: true) }
    }
    @Published private(set) var canLoadMore: Bool = false

    private let pokemonRepository: PokemonRepository
    private let disposeBag = DisposeBag()

    private var allItems: [Pokemon] = []
    private let pageSize: Int = 20
    private var currentPage: Int = 1

    init(pokemonRepository: PokemonRepository) {
        self.pokemonRepository = pokemonRepository
        loadPokemon()
    }

    // Loads the first 151 Pokemon from the repository.
    func loadPokemon() {
        isLoading = true
        errorMessage = nil

        pokemonRepository.fetchAllPokemon()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] items in
                guard let self else { return }
                self.isLoading = false
                self.allItems = items
                self.applyFilterAndPagination(reset: true)
            }, onFailure: { [weak self] error in
                guard let self else { return }
                self.isLoading = false
                self.errorMessage = self.errorMessage(from: error)
            })
            .disposed(by: disposeBag)
    }

    // Triggers pagination when the user reaches the tail of the list.
    func loadNextPageIfNeeded(currentItem: Pokemon?) {
        guard let currentItem else { return }
        guard canLoadMore else { return }

        let thresholdIndex = items.index(items.endIndex, offsetBy: -5)
        if items.firstIndex(where: { $0.id == currentItem.id }) == thresholdIndex {
            currentPage += 1
            applyFilterAndPagination(reset: false)
        }
    }

    // Restarts the fetch after an error.
    func retry() {
        loadPokemon()
    }

    // Applies search and page slicing in a functional style.
    private func applyFilterAndPagination(reset: Bool) {
        if reset { currentPage = 1 }

        let filtered = allItems.filter { item in
            query.isEmpty || item.name.localizedCaseInsensitiveContains(query)
        }

        let endIndex = min(filtered.count, currentPage * pageSize)
        items = Array(filtered.prefix(endIndex))
        canLoadMore = endIndex < filtered.count
    }

    // Maps domain errors to user-facing messages.
    private func errorMessage(from error: Error) -> String {
        if let pokemonError = error as? PokemonError {
            switch pokemonError {
            case .invalidURL:
                return "Invalid URL."
            case .network:
                return "Network error."
            case .decoding:
                return "Decoding error."
            case .unknown:
                return "Unknown error."
            }
        }
        return "Unexpected error."
    }
}
