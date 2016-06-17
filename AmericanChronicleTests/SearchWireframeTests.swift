import XCTest
@testable import AmericanChronicle

class SearchWireframeTests: XCTestCase {

    var subject: SearchWireframe!

    override func setUp() {
        super.setUp()
        subject = SearchWireframe()
    }

    func testThat_whenAskedToPresentSearch_itPresentsItsView_wrappedInANavigationController() {
        let window = UIWindow()
        subject.beginAsRootFromWindow(window)
        let nvc = window.rootViewController as? UINavigationController
        XCTAssertTrue(nvc?.topViewController is SearchViewController)
    }
}
