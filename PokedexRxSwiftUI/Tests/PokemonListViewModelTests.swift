import XCTest
import RxSwift
@testable import PokedexRxSwiftUI

final class PokemonListViewModelTests: XCTestCase {
    func testInitialLoadCreatesFirstPage() {
        let repository = TestPokemonRepository(count: 45)
        let viewModel = PokemonListViewModel(pokemonRepository: repository)

        let expectation = XCTestExpectation(description: "Wait for load")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(viewModel.items.count, 20)
            XCTAssertTrue(viewModel.canLoadMore)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testSearchFiltersItems() {
        let repository = TestPokemonRepository(count: 10)
        let viewModel = PokemonListViewModel(pokemonRepository: repository)

        let expectation = XCTestExpectation(description: "Wait for load")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            viewModel.query = "pokemon-1"
            XCTAssertTrue(viewModel.items.allSatisfy { $0.name.contains("pokemon-1") })
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

private struct TestPokemonRepository: PokemonRepository {
    let count: Int

    func fetchAllPokemon() -> Single<[Pokemon]> {
        let items = (1...count).map { id in
            Pokemon(id: id, name: "pokemon-\(id)", imageURL: URL.pokemonSpriteURL(id: id)!)
        }
        return .just(items)
    }

    func fetchPokemonDetail(id: Int) -> Single<PokemonDetail> {
        let detail = PokemonDetail(
            id: id,
            name: "pokemon-\(id)",
            height: 7,
            weight: 69,
            baseExperience: 64,
            order: id,
            isDefault: true,
            locationAreaEncounters: "https://pokeapi.co/api/v2/pokemon/\(id)/encounters",
            species: NamedResource(name: "species-\(id)", url: "https://pokeapi.co/api/v2/pokemon-species/\(id)/"),
            sprites: PokemonSprites(frontDefault: nil, frontShiny: nil, backDefault: nil, backShiny: nil),
            abilities: [],
            forms: [],
            gameIndices: [],
            heldItems: [],
            moves: [],
            stats: [],
            types: []
        )
        return .just(detail)
    }

    func fetchLocationEncounters(urlString: String) -> Single<[LocationEncounter]> {
        return .just([])
    }
}
