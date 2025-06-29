//
//  TunesMusicUITests.swift
//  TunesMusicUITests
//
//  Created by Fajar Subeki on 28/06/25.
//

import XCTest

final class TunesMusicUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testSearchMusic() throws {
        let app = XCUIApplication()
        app.launch()

        let searchField = app.textFields["Search artist"]
        XCTAssertTrue(searchField.exists)

        searchField.tap()
        searchField.typeText("Taylor Swift")

        app.keyboards.buttons["return"].tap()

        let firstCell = app.cells.element(boundBy: 0)
        let exists = firstCell.waitForExistence(timeout: 5)
        XCTAssertTrue(exists, "Expected song list to appear after search")
    }
}
