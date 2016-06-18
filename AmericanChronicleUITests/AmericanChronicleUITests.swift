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

    func testHappyPath() {

        let app = XCUIApplication()
        app.tables.textFields["Search all Newspapers"].typeText("mark twain")
        snapshot("01Search")

        app.buttons["Search"].tap()
        let cell = app.tables.childrenMatchingType(.Cell).elementBoundByIndex(0)
        expectationForPredicate(NSPredicate(format: "self.exists == true"), evaluatedWithObject: cell, handler: nil)
        waitForExpectationsWithTimeout(10.0, handler: nil)
        XCTAssert(cell.exists)
        let coordinate = cell.coordinateWithNormalizedOffset(CGVector(dx: 0.5, dy: 0.5))
        coordinate.tap()

        let cancelLoadButton = app.buttons["Cancel Page Load"]

        expectationForPredicate(NSPredicate(format: "self.hittable == false"), evaluatedWithObject: cancelLoadButton, handler: nil)
        waitForExpectationsWithTimeout(10.0, handler: nil)

        let element = app.childrenMatchingType(.Window)
            .elementBoundByIndex(0).childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element
        snapshot("02PageZoomedOut")
        element.pinchWithScale(2.0, velocity: 1.0)

        XCUIDevice.sharedDevice().orientation = .LandscapeLeft

        snapshot("03PageZoomedIn")
        app.buttons["Share"].tap()
        snapshot("06Share")

        let cancelButton = app.sheets.buttons["Cancel"]
        cancelButton.tap()
        app.buttons["UIAccessoryButtonX"].pressForDuration(0.6)
    }
}
