//
//  AmericanChronicleUITests.swift
//  AmericanChronicleUITests
//
//  Created by Ryan Peterson on 3/13/16.
//  Copyright © 2016 ryanipete. All rights reserved.
//

import XCTest

class AmericanChronicleUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        let app = XCUIApplication()
        setupSnapshot(app)
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let app = XCUIApplication()
        app.tables.textFields["Search all Newspapers"].typeText("mark twain")
        snapshot("01Search")
        app.tables.staticTexts["Earliest Date"].tap()

        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Mar"].tap()
        app.buttons["Day"].tap()
        elementsQuery.buttons["17"].tap()
        app.buttons["Year"].tap()
        snapshot("02DatePicker")

        app.navigationBars["Earliest Date"].buttons["Save"].tap()
        app.tables.staticTexts["U.S. States"].tap()
        app.collectionViews.staticTexts["California"].tap()
        snapshot("03StatePicker")
        app.navigationBars["U.S. States"].buttons["Save"].tap()

        app.tables.childrenMatchingType(.Cell).elementBoundByIndex(0).staticTexts["San Francisco, California"].tap()
        snapshot("04PageZoomedOut")

//        let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element

        snapshot("05PageZoomedIn")
        app.buttons["Share"].tap()
        snapshot("06Share")
        
        let cancelButton = app.sheets.buttons["Cancel"]
        cancelButton.tap()
        app.buttons["UIAccessoryButtonX"].pressForDuration(0.6);

    }
    
}
