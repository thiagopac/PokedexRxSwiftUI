import SwiftUI

struct PokemonRowView: View {
    let pokemon: Pokemon
    let imageLoader: ImageLoader

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImageView(imageLoader: imageLoader, url: pokemon.imageURL)

            Text(pokemon.name.capitalizedFirstLetter)
                .font(.headline)
                .foregroundColor(Color.appPrimaryText)

            Text("#\(pokemon.id)")
                .font(.subheadline)
                .foregroundColor(Color.appSecondaryText)
        }
        .padding(12)
        .background(Color.appSecondaryBackground)
        .cornerRadius(16)
        .accessibilityIdentifier("pokemon_\(pokemon.id)")
    }
}
