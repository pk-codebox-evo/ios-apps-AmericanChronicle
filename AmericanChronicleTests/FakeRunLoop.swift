@testable import AmericanChronicle

class FakeRunLoop: RunLoopInterface {
    var addTimer_wasCalled_withTimer: NSTimer?
    func addTimer(timer: NSTimer, forMode mode: String) {
        addTimer_wasCalled_withTimer = timer
    }
}
