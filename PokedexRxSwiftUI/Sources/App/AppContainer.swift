import Foundation

final class AppContainer: ObservableObject {
    let pokemonRepository: PokemonRepository
    let imageLoader: ImageLoader

    private init(pokemonRepository: PokemonRepository, imageLoader: ImageLoader) {
        self.pokemonRepository = pokemonRepository
        self.imageLoader = imageLoader
    }

    // Production dependencies for real networking.
    static func live() -> AppContainer {
        let networkClient = URLSessionNetworkClient()
        let repository = DefaultPokemonRepository(networkClient: networkClient)
        let imageCache = ImageCacheActor()
        let imageLoader = DefaultImageLoader(networkClient: networkClient, cache: imageCache)
        return AppContainer(pokemonRepository: repository, imageLoader: imageLoader)
    }

    // UI test dependencies with deterministic data.
    static func uiTest() -> AppContainer {
        let repository = MockPokemonRepository()
        let imageLoader = MockImageLoader()
        return AppContainer(pokemonRepository: repository, imageLoader: imageLoader)
    }

    // Factory for view models to keep creation centralized.
    @MainActor
    func makePokemonListViewModel() -> PokemonListViewModel {
        PokemonListViewModel(pokemonRepository: pokemonRepository)
    }

    @MainActor
    func makePokemonDetailViewModel(pokemonId: Int) -> PokemonDetailViewModel {
        PokemonDetailViewModel(pokemonRepository: pokemonRepository, pokemonId: pokemonId)
    }
}
