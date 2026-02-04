import Foundation

enum AppMode {
    case live
    case uiTest
}

struct AppEnvironment {
    // Uses launch arguments to switch dependencies.
    static func makeContainer() -> AppContainer {
        let mode = AppEnvironment.resolveMode()
        switch mode {
        case .live:
            return AppContainer.live()
        case .uiTest:
            return AppContainer.uiTest()
        }
    }

    private static func resolveMode() -> AppMode {
        let arguments = ProcessInfo.processInfo.arguments
        if arguments.contains("-ui-testing") {
            return .uiTest
        }
        return .live
    }
}
