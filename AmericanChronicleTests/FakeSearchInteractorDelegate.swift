@testable import AmericanChronicle

class FakeSearchInteractorDelegate: SearchInteractorDelegate {
    var searchForTerm_didFinish_wasCalled = false
    var searchForTerm_didFinish_wasCalled_withParameters: SearchParameters?
    var searchForTerm_didFinish_wasCalled_withResults: SearchResults?
    var searchForTerm_didFinish_wasCalled_withError: NSError?
    func search(parameters: SearchParameters, didFinishWithResults results: SearchResults?, error: NSError?) {
        searchForTerm_didFinish_wasCalled = true
        searchForTerm_didFinish_wasCalled_withParameters = parameters
        searchForTerm_didFinish_wasCalled_withResults = results
        searchForTerm_didFinish_wasCalled_withError = error
    }
}
