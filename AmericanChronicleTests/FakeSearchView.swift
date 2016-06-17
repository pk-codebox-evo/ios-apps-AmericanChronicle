@testable import AmericanChronicle

class FakeSearchView: SearchUserInterface {

    weak var delegate: SearchUserInterfaceDelegate?
    var searchTerm: String?
    var earliestDate: String?
    var latestDate: String?
    var usStateNames: String?

    var setViewState_wasCalled_withState: SearchViewState?
    func setViewState(state: SearchViewState) {
        setViewState_wasCalled_withState = state
    }

    func setBottomContentInset(bottom: CGFloat) {

    }

    func resignFirstResponder() -> Bool {
        return true
    }


}
