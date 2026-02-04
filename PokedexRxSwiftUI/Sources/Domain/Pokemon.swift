import Foundation

struct Pokemon: Identifiable, Equatable {
    let id: Int
    let name: String
    let imageURL: URL
}

struct PokemonPage {
    let items: [Pokemon]
    let canLoadMore: Bool
}
