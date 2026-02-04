import Foundation
import SwiftUI

extension String {
    // Extracts the last numeric path component from a URL string.
    var pokemonId: Int? {
        let trimmed = trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let lastComponent = trimmed.split(separator: "/").last
        return lastComponent.flatMap { Int($0) }
    }

    var capitalizedFirstLetter: String {
        guard let first = first else { return self }
        return String(first).uppercased() + dropFirst()
    }
}

extension URL {
    static func pokemonSpriteURL(id: Int) -> URL? {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
    }
}

extension PokemonDetail {
    var imageURL: URL {
        URL.pokemonSpriteURL(id: id) ?? URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!
    }
}

extension Color {
    static let appBackground = Color(UIColor.systemBackground)
    static let appSecondaryBackground = Color(UIColor.secondarySystemBackground)
    static let appPrimaryText = Color(UIColor.label)
    static let appSecondaryText = Color(UIColor.secondaryLabel)
}
