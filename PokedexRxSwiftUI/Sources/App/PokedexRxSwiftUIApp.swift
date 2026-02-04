import SwiftUI

@main
struct PokedexRxSwiftUIApp: App {
    // Centralized environment selection for app and tests.
    private let container = AppEnvironment.makeContainer()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: container.makePokemonListViewModel())
                .environmentObject(container)
        }
    }
}
