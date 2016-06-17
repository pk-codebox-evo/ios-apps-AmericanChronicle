import XCTest
import Alamofire
@testable import AmericanChronicle

class SearchPagesServiceTests: XCTestCase {

    var subject: SearchPagesService!
    var manager: FakeManager!

    override func setUp() {
        super.setUp()
        manager = FakeManager()
        subject = SearchPagesService(manager: manager)
    }

    func testThat_whenStartSearchIsCalled_withAnEmptyTerm_itImmediatelyReturnsAnInvalidParameterError() {
        let params = SearchParameters(term: "",
                                      states: ["Alabama", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        var error: NSError? = nil
        subject.startSearch(params, page: 3, contextID: "context") { _, err in
            error = err as? NSError
        }
        XCTAssert(error?.isInvalidParameterError() ?? false)
    }

    func testThat_whenStartSearchIsCalled_withAPageBelowOne_itImmediatelyReturnsAnInvalidParameterError() {
        let params = SearchParameters(term: "Jibberish",
                                      states: ["Alabama", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        var error: NSError? = nil
        subject.startSearch(params, page: 0, contextID: "context") { _, err in
            error = err as? NSError
        }
        XCTAssert(error?.isInvalidParameterError() ?? false)
    }

    func testThat_whenStartSearchIsCalled_withADuplicateRequest_itImmediatelyReturnsADuplicateRequestError() {
        let params = SearchParameters(term: "Jibberish",
                                      states: ["Alabama", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.startSearch(params, page: 2, contextID: "context") { _, err in }
        var error: NSError? = nil
        subject.startSearch(params, page: 2, contextID: "context") { _, err in
            error = err as? NSError
        }
        XCTAssert(error?.isDuplicateRequestError() ?? false)
    }

    func testThat_whenStartSearchIsCalled_withValidParameters_itStartsARequest_withTheCorrectTerm() {
        let params = SearchParameters(term: "tsunami wave",
                                      states: ["Alabama", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.startSearch(params, page: 4, contextID: "context") { _, _ in }
        XCTAssert(manager.request_wasCalled_withURLString?.URLString.containsString("proxtext=tsunami+wave") ?? false)
    }

    func testThat_whenStartSearchIsCalled_withValidParameters_itStartsARequest_withTheCorrectStates() {
        let params = SearchParameters(term: "tsunami",
                                      states: ["New York", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.startSearch(params, page: 4, contextID: "context") { _, _ in }
        XCTAssert(manager.request_wasCalled_withURLString?.URLString.hasSuffix("state=New+York&state=Colorado") ?? false)
    }

    func testThat_whenStartSearchIsCalled_withValidParameters_itStartsARequest_withTheCorrectPage() {
        let params = SearchParameters(term: "Jibberish",
                                      states: ["Alabama", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.startSearch(params, page: 4, contextID: "context") { _, _ in }
        XCTAssertEqual(manager.request_wasCalled_withParameters?["page"] as? Int, 4)
    }

    func testThat_whenASearchSucceeds_itCallsTheCompletionHandler_withTheSearchResults() {
        var returnedResults: SearchResults?
        let params = SearchParameters(term: "Jibberish",
                                      states: ["Alabama", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.startSearch(params, page: 2, contextID: "context") { results, _ in
            returnedResults = results
        }
        let expectedResults = SearchResults()
        let result: Result<SearchResults, NSError> = .Success(expectedResults)
        let response = Response(request: nil, response: nil, data: nil, result: result)
        manager.stubbedReturnValue.finishWithResponseObject(response)
        XCTAssertEqual(returnedResults, expectedResults)
    }

    func testThat_whenASearchFails_itCallsTheCompletionHandler_withTheError() {
        let params = SearchParameters(term: "Jibberish",
                                      states: ["Alabama", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        var returnedError: NSError?
        let request = FakeRequest()
        manager.stubbedReturnValue = request
        subject.startSearch(params, page: 2, contextID: "context") { _, error in
            returnedError = error as? NSError
        }
        let expectedError = NSError(code: .InvalidParameter, message: "")
        let result: Result<SearchResults, NSError> = .Failure(expectedError)
        let response = Response(request: nil, response: nil, data: nil, result: result)
        request.finishWithResponseObject(response)
        XCTAssertEqual(returnedError, expectedError)
    }

    func testThat_byTheTimeTheCompletionHandlerIsCalled_theRequestIsNotInProgress() {
        var isInProgress = true
        let request = FakeRequest()
        let params = SearchParameters(term: "Jibberish",
                                      states: ["Alabama", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        manager.stubbedReturnValue = request
        subject.startSearch(params, page: 2, contextID: "context") { _, error in
            isInProgress = self.subject.isSearchInProgress(params, page: 2, contextID: "context")
        }
        let result: Result<SearchResults, NSError> = .Failure(NSError(code: .DuplicateRequest, message: nil))
        let response = Response(request: nil, response: nil, data: nil, result: result)
        request.finishWithResponseObject(response)
        XCTAssertFalse(isInProgress)
    }

    func testThat_whenCancelSearchIsCalled_withParametersOfAnActiveRequest_itCancelsTheRequest() {
        let params = SearchParameters(term: "Jibberish",
                                      states: ["Alabama", "Colorado"],
                                      earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                      latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.startSearch(params, page: 2, contextID: "context") { _, _ in }
        subject.cancelSearch(params, page: 2, contextID: "context")
        XCTAssert(manager.stubbedReturnValue.cancel_wasCalled)
    }

    func testThat_whenCancelSearchIsCalled_withParametersThatDoNotMatchAnActiveRequest_itDoesNotCancelsTheActiveRequest() {
        let activeParams = SearchParameters(term: "Jibberish",
                                            states: ["Alabama", "Colorado"],
                                            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                            latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.startSearch(activeParams, page: 2, contextID: "context") { _, _ in }
        let inactiveParams = SearchParameters(term: "Jabberish",
                                              states: ["Alabama", "Colorado"],
                                              earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                              latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.cancelSearch(inactiveParams, page: 2, contextID: "context")
        XCTAssertFalse(manager.stubbedReturnValue.cancel_wasCalled)
    }

    func testThat_whenTheSpecifiedSearchIsActive_isSearchInProgress_returnsTrue() {
        let activeParams = SearchParameters(term: "Jibberish",
                                            states: ["Alabama", "Colorado"],
                                            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                            latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.startSearch(activeParams, page: 2, contextID: "context") { _, _ in }
        XCTAssert(subject.isSearchInProgress(activeParams, page: 2, contextID: "context"))
    }

    func testThat_whenTheSpecifiedSearchIsNotActive_isSearchInProgress_returnsFalse() {
        let activeParams = SearchParameters(term: "Jibberish",
                                            states: ["Alabama", "Colorado"],
                                            earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                            latestDayMonthYear: Search.latestPossibleDayMonthYear)
        subject.startSearch(activeParams, page: 2, contextID: "context") { _, _ in }
        let inactiveParams = SearchParameters(term: "Jibberish",
                                              states: ["Alabama"],
                                              earliestDayMonthYear: Search.earliestPossibleDayMonthYear,
                                              latestDayMonthYear: Search.latestPossibleDayMonthYear)
        XCTAssertFalse(subject.isSearchInProgress(inactiveParams, page: 2, contextID: "context"))
    }
}
