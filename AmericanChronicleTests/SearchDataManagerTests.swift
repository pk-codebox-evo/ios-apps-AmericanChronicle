//
//  SearchDataManagerTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/18/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

@testable import AmericanChronicle
import XCTest

class SearchDataManagerTests: XCTestCase {

    var service: FakeSearchPagesService!
    var subject: SearchDataManager!

    override func setUp() {
        super.setUp()
        service = FakeSearchPagesService()
        subject = SearchDataManager()
        subject.service = service
    }

    func testThat_whenStartSearchIsCalled_itStartsAServiceSearch_withTheSameParameters() {
        let params = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"])
        subject.startSearch(params, page: 0, completionHandler: { _, _ in })
        XCTAssertEqual(service.startSearch_wasCalled_withParameters, params)
    }

    func testThat_whenStartSearchIsCalled_itStartsAServiceSearch_withTheSamePage() {
        let params = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"])
        subject.startSearch(params, page: 11, completionHandler: { _, _ in })
        XCTAssertEqual(service.startSearch_wasCalled_withPage, 11)
    }

    func testThat_whenCancelSearchIsCalled_itCalls_cancelSearch_onTheService_withTheSameParameters() {
        let params = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"])
        subject.cancelSearch(params, page: 0)
        XCTAssertEqual(service.cancelSearch_wasCalled_withParameters, params)
    }

    func testThat_whenCancelSearchIsCalled_itCalls_cancelSearch_onTheService_withTheSamePage() {
        let params = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"])
        subject.cancelSearch(params, page: 7)
        XCTAssertEqual(service.cancelSearch_wasCalled_withPage, 7)
    }

    func testThat_whenIsSearchInProgressIsCalled_itCalls_isSearchInProgress_onTheService_withTheSameParameters() {
        let params = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"])
        subject.isSearchInProgress(params, page: 0)
        XCTAssertEqual(service.isSearchInProgress_wasCalled_withParameters, params)
    }

    func testThat_whenIsSearchInProgressIsCalled_itCallsIsSearchInProgress_onTheService_withTheSamePage() {
        let params = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"])
        subject.isSearchInProgress(params, page: 4)
        XCTAssertEqual(service.isSearchInProgress_wasCalled_withPage, 4)
    }

    func testThat_whenIsSearchInProgressIsCalled_itReturnsTheValueReturnedByCalling_isSearchInProgress_onTheService() {
        service.isSearchInProgress_mock_returnValue = true
        XCTAssert(subject.isSearchInProgress(SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"]), page: 0))
    }

    func testThat_whenASearchSucceeds_itCallsTheAssociatedCompletionHandler_withTheSearchResults() {
        let params = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"])
        var searchResults: SearchResults?
        subject.startSearch(params, page: 11, completionHandler: { results, _ in
            searchResults = results
        })
        let mockResults = SearchResults()
        service.startSearch_wasCalled_withCompletionHandler?(mockResults, nil)
        XCTAssertEqual(searchResults, mockResults)
    }

    func testThat_whenASearchFails_itCallsTheAssociatedCompletionHandler_withTheError() {
        let params = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"])
        var searchError: NSError?
        subject.startSearch(params, page: 11, completionHandler: { _, error in
            searchError = error
        })
        let mockError = NSError(domain: "", code: 0, userInfo: nil)
        service.startSearch_wasCalled_withCompletionHandler?(nil, mockError)
        XCTAssertEqual(searchError, mockError)
    }
}
