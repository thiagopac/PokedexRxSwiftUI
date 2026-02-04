import Foundation
import RxSwift

@MainActor
final class PokemonDetailViewModel: ObservableObject {
    @Published private(set) var detail: PokemonDetail? = nil
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil
    @Published private(set) var encounters: [LocationEncounter] = []
    @Published private(set) var isLoadingEncounters: Bool = false

    private let pokemonRepository: PokemonRepository
    private let pokemonId: Int
    private let disposeBag = DisposeBag()

    init(pokemonRepository: PokemonRepository, pokemonId: Int) {
        self.pokemonRepository = pokemonRepository
        self.pokemonId = pokemonId
    }

    // Loads Pokemon detail from the API.
    func load() {
        guard detail == nil else { return }
        isLoading = true
        errorMessage = nil

        pokemonRepository.fetchPokemonDetail(id: pokemonId)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] detail in
                guard let self else { return }
                self.isLoading = false
                self.detail = detail
                self.loadEncounters(urlString: detail.locationAreaEncounters)
            }, onFailure: { [weak self] error in
                guard let self else { return }
                self.isLoading = false
                self.errorMessage = self.errorMessage(from: error)
            })
            .disposed(by: disposeBag)
    }

    func retry() {
        detail = nil
        encounters = []
        load()
    }

    private func loadEncounters(urlString: String) {
        isLoadingEncounters = true

        pokemonRepository.fetchLocationEncounters(urlString: urlString)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] encounters in
                guard let self else { return }
                self.isLoadingEncounters = false
                self.encounters = encounters
            }, onFailure: { [weak self] _ in
                guard let self else { return }
                self.isLoadingEncounters = false
            })
            .disposed(by: disposeBag)
    }

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
