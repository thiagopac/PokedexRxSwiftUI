import XCTest

final class PokedexRxSwiftUIUITests: XCTestCase {
    func testSearchFiltersResults() {
        let app = XCUIApplication()
        app.launchArguments.append("-ui-testing")
        app.launch()

        let searchField = app.textFields["Search Pokemon"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 2.0))
        searchField.tap()
        searchField.typeText("pokemon-1")

        let firstCell = app.otherElements["pokemon_1"]
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2.0))
    }
}
