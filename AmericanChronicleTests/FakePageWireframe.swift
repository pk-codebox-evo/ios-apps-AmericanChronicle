@testable import AmericanChronicle

class FakePageWireframe: PageWireframe {
    var userDidTapDone_wasCalled = false
    override func dismissPageScreen() {
        userDidTapDone_wasCalled = true
    }
}
