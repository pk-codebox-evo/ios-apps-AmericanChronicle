@testable import AmericanChronicle

class FakeSearchInteractor: SearchInteractorInterface {

    var delegate: SearchInteractorDelegate?

    var fetchNextPageOfResults_wasCalled_withParameters: SearchParameters?
    func fetchNextPageOfResults(parameters: SearchParameters) {
        fetchNextPageOfResults_wasCalled_withParameters = parameters
    }

    var fake_isSearchInProgress = false
    func isSearchInProgress() -> Bool {
        return fake_isSearchInProgress
    }

    var cancelLastSearch_wasCalled = false
    func cancelLastSearch() {
        cancelLastSearch_wasCalled = true
    }
}
