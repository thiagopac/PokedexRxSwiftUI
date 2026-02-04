import XCTest
@testable import PokedexRxSwiftUI

final class URLParsingTests: XCTestCase {
    func testPokemonIdParsing() {
        let url = "https://pokeapi.co/api/v2/pokemon/25/"
        XCTAssertEqual(url.pokemonId, 25)
    }

    func testSpriteURLBuilder() {
        let url = URL.pokemonSpriteURL(id: 7)
        XCTAssertEqual(url?.absoluteString, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png")
    }
}
