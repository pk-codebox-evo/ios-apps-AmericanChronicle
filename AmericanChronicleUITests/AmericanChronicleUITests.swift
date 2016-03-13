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
        let app = XCUIApplication()
        app.tables.textFields["Search all Newspapers"].typeText("mark twain")
        snapshot("01Search")
//        app.tables.staticTexts["Earliest Date"].tap()
//
//        
//        let elementsQuery = app.scrollViews.otherElements
//        elementsQuery.buttons["Mar"].tap()
//        app.buttons["Day"].tap()
//        elementsQuery.buttons["17"].tap()
//        app.buttons["Year"].tap()

//        app.navigationBars["Earliest Date"].buttons["Save"].tap()
//        app.tables.staticTexts["U.S. States"].tap()
//        app.collectionViews.staticTexts["California"].tap()
//        app.navigationBars["U.S. States"].buttons["Save"].tap()

        app.tables.childrenMatchingType(.Cell).elementBoundByIndex(0).staticTexts["Washington, District of Columbia"].tap()

        let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element
        snapshot("02PageZoomedOut")
        element.pinchWithScale(2.0, velocity: 1.0)

        snapshot("03PageZoomedIn")
        app.buttons["Share"].tap()
        snapshot("06Share")
        
        let cancelButton = app.sheets.buttons["Cancel"]
        cancelButton.tap()
        app.buttons["UIAccessoryButtonX"].pressForDuration(0.6);

    }
    
}
