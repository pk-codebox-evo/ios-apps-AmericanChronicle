//
//  SearchPagesServiceTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/24/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import XCTest
import AmericanChronicle

class SearchPagesServiceTests: XCTestCase {

    var subject: SearchPagesService!
    var manager: FakeManager!

    override func setUp() {
        super.setUp()
        manager = FakeManager()
        subject = SearchPagesService(manager: manager)
    }
    
    func testThat_whenStartSearchIsCalled_withAnEmptyTerm_itImmediatelyReturnsAnInvalidParameterError() {
        var error: NSError? = nil
        subject.startSearch("", page: 3, contextID: "context") { _, err in
            error = err as? NSError
        }
        XCTAssert(error?.isInvalidParameterError() ?? false)
    }

    func testThat_whenStartSearchIsCalled_withAPageBelowOne_itImmediatelyReturnsAnInvalidParameterError() {
        var error: NSError? = nil
        subject.startSearch("volcano", page: 0, contextID: "context") { _, err in
            error = err as? NSError
        }
        XCTAssert(error?.isInvalidParameterError() ?? false)
    }

    func testThat_whenStartSearchIsCalled_withTheCorrectParameters_itStartsARequest_withTheCorrectTerm() {
        subject.startSearch("tsunami", page: 4, contextID: "context") { _, _ in }
        XCTAssertEqual(manager.request_wasCalled_withParameters?["proxtext"] as? String, "tsunami")
    }

    func testThat_whenStartSearchIsCalled_withTheCorrectParameters_itStartsARequest_withTheCorrectPage() {
        subject.startSearch("tsunami", page: 4, contextID: "context") { _, _ in }
        XCTAssertEqual(manager.request_wasCalled_withParameters?["page"] as? Int, 4)
    }

    func testThat_whenStartSearchIsCalled_withADuplicateRequest_itImmediatelyReturnsADuplicateRequestError() {

        subject.startSearch("volcano", page: 2, contextID: "context") { _, err in }
        var error: NSError? = nil
        subject.startSearch("volcano", page: 2, contextID: "context") { _, err in
            error = err as? NSError
        }

        XCTAssert(error?.isDuplicateRequestError() ?? false)
    }

    func testThat_whenASearchSucceeds_itCallsTheCompletionHandler_withTheSearchResults() {
        var returnedResults: SearchResults?
        subject.startSearch("volcano", page: 2, contextID: "context") { results, _ in
            returnedResults = results
        }
        let expectedResults = SearchResults()
        manager.stubbedReturnValue.finishWithResponseObject(expectedResults, error: nil)
        XCTAssertEqual(returnedResults, expectedResults)
    }

    func testThat_whenASearchFails_itCallsTheCompletionHandler_withTheError() {
        var returnedError: NSError?
        let request = FakeRequest()
        manager.stubbedReturnValue = request
        subject.startSearch("volcano", page: 2, contextID: "context") { _, error in
            returnedError = error as? NSError
        }
        let expectedError = NSError(code: .InvalidParameter, message: "")
        let obj: SearchResults? = nil
        request.finishWithResponseObject(obj, error: expectedError)
        XCTAssertEqual(returnedError, expectedError)
    }

    func testThat_byTheTimeTheCompletionHandlerIsCalled_theRequestIsNoConsideredToBeInProgress() {
        var isInProgress = true
        let request = FakeRequest()
        manager.stubbedReturnValue = request
        subject.startSearch("volcano", page: 2, contextID: "context") { _, error in
            isInProgress = self.subject.isSearchInProgress("volcano", page: 2, contextID: "context")
        }
        let obj: SearchResults? = nil
        request.finishWithResponseObject(obj, error: nil)
        XCTAssertFalse(isInProgress)
    }
    
}
