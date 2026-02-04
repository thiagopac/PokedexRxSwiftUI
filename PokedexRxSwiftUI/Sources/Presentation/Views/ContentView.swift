import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var container: AppContainer
    @StateObject private var viewModel: PokemonListViewModel

    init(viewModel: PokemonListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // Main screen with search, grid, and error handling.
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                VStack(spacing: 12) {
                    SearchBarView(text: $viewModel.query)
                        .padding(.horizontal)

                    if viewModel.isLoading && viewModel.items.isEmpty {
                        LoadingView(title: "Loading Pokemon")
                    } else if let errorMessage = viewModel.errorMessage {
                        ErrorView(message: errorMessage, action: viewModel.retry)
                            .padding(.horizontal)
                    } else {
                        PokemonGridView(
                            items: viewModel.items,
                            onItemAppear: { item in
                                viewModel.loadNextPageIfNeeded(currentItem: item)
                            }
                        )
                    }
                }
                .padding(.top, 8)
            }
            .navigationTitle("Pokedex")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

private struct PokemonGridView: View {
    @EnvironmentObject private var container: AppContainer
    let items: [Pokemon]
    let onItemAppear: (Pokemon) -> Void

    // Adapts to size changes using an adaptive grid.
    var body: some View {
        GeometryReader { proxy in
            let columns = gridColumns(for: proxy.size.width)

            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(items) { pokemon in
                        NavigationLink(destination: PokemonDetailView(viewModel: container.makePokemonDetailViewModel(pokemonId: pokemon.id))) {
                            PokemonRowView(pokemon: pokemon, imageLoader: container.imageLoader)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onAppear { onItemAppear(pokemon) }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 12)
            }
        }
    }

    private func gridColumns(for width: CGFloat) -> [GridItem] {
        let minWidth: CGFloat = width > 700 ? 200 : 140
        return [GridItem(.adaptive(minimum: minWidth), spacing: 16)]
    }
}
