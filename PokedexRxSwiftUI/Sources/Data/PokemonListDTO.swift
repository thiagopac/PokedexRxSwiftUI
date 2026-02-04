import Foundation

struct PokemonListDTO: Decodable {
    let results: [PokemonEntryDTO]
}

struct PokemonEntryDTO: Decodable {
    let name: String
    let url: String
}
