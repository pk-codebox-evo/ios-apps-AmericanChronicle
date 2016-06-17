@testable import AmericanChronicle

class FakeSearchPagesService: SearchPagesServiceInterface {

    var startSearch_wasCalled_withParameters: SearchParameters?
    var startSearch_wasCalled_withPage: Int?
    var startSearch_wasCalled_withContextID: String?
    var startSearch_wasCalled_withCompletionHandler: ((SearchResults?, ErrorType?) -> Void)?
    func startSearch(parameters: SearchParameters, page: Int, contextID: String, completionHandler: ((SearchResults?, ErrorType?) -> Void)) {
        startSearch_wasCalled_withParameters = parameters
        startSearch_wasCalled_withPage = page
        startSearch_wasCalled_withContextID = contextID
        startSearch_wasCalled_withCompletionHandler = completionHandler
        completionHandler(nil, nil)
    }

    var isSearchInProgress_wasCalled_withParameters: SearchParameters?
    var isSearchInProgress_wasCalled_withPage: Int?
    var isSearchInProgress_wasCalled_withContextID: String?
    var isSearchInProgress_mock_returnValue = false
    func isSearchInProgress(parameters: SearchParameters, page: Int, contextID: String) -> Bool {
        isSearchInProgress_wasCalled_withParameters = parameters
        isSearchInProgress_wasCalled_withPage = page
        isSearchInProgress_wasCalled_withContextID = contextID
        return isSearchInProgress_mock_returnValue
    }

    var cancelSearch_wasCalled_withParameters: SearchParameters?
    var cancelSearch_wasCalled_withPage: Int?
    var cancelSearch_wasCalled_withContextID: String?
    func cancelSearch(parameters: SearchParameters, page: Int, contextID: String) {
        cancelSearch_wasCalled_withParameters = parameters
        cancelSearch_wasCalled_withPage = page
        cancelSearch_wasCalled_withContextID = contextID
    }
}
