//
//  ToDoUITests.swift
//  ToDoUITests
//
//  Created by Kazuki Ohara on 2019/02/14.
//  Copyright © 2019 Kazuki Ohara. All rights reserved.
//

import XCTest

class ToDoUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
    }

    func testExample() {
        let app = XCUIApplication()
        app.navigationBars["ToDo.ItemListView"].buttons["Add"].tap()

        let titleTextField = app.textFields["Title"]
        titleTextField.tap()
        titleTextField.typeText("Meeting")

        let dateTextField = app.textFields["Date"]
        dateTextField.tap()
        dateTextField.typeText("02/22/2018")

        let locationTextField = app.textFields["Location"]
        locationTextField.tap()
        locationTextField.typeText("Office")

        let addressTextField = app.textFields["Address"]
        addressTextField.tap()
        addressTextField.typeText("Infinite Loop 1, Cupertino")

        let descriptionTextField = app.textFields["Description"]
        descriptionTextField.tap()
        descriptionTextField.typeText("Bring iPad")

        app.buttons["Save"].tap()

        XCTAssertTrue(app.tables.staticTexts["Meeting"].exists)
        XCTAssertTrue(app.tables.staticTexts["02/22/2018"].exists)
        XCTAssertTrue(app.tables.staticTexts["Office"].exists)
    }
}
