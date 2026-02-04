import Foundation

enum PokemonError: Error, Equatable {
    case invalidURL
    case network
    case decoding
    case unknown
}
