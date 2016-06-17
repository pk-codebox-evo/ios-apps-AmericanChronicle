import XCTest
@testable import AmericanChronicle

class USStatePickerWireframeTests: XCTestCase {
    var subject: USStatePickerWireframe!
    var delegate: FakeUSStatePickerWireframeDelegate!
    var presenter: FakeUSStatePickerPresenter!

    override func setUp() {
        super.setUp()
        delegate = FakeUSStatePickerWireframeDelegate()
        presenter = FakeUSStatePickerPresenter()
        subject = USStatePickerWireframe(delegate: delegate, presenter: presenter)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testThat_onInit_itSetsThePresenterWireframe() {
        XCTAssertEqual(presenter.wireframe as? USStatePickerWireframe, subject)
    }

    func testThat_onPresent_itSets_presentedViewController() {
        subject.presentFromViewController(nil, withSelectedStateNames: [])
        let nvc = subject.presentedViewController as? UINavigationController
        XCTAssert(nvc?.topViewController is USStatePickerViewController)
    }

    func testThat_onPresent_itAsksThePresenterToConfigureTheView_withTheCorrectViewType() {
        subject.presentFromViewController(nil, withSelectedStateNames: [])
        XCTAssert(presenter.didCallConfigureWithUserInterface is USStatePickerViewController)
    }

    func testThat_onPresent_itAsksThePresenterToConfigureTheView_withTheSameSelectedStateNames() {
        subject.presentFromViewController(nil, withSelectedStateNames: ["One", "Two"])
        XCTAssertEqual(presenter.didCallConfigureWithSelectedStateNames!, ["One", "Two"])
    }

}
