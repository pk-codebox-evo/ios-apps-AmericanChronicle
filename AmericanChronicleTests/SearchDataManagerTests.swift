//
//  SearchDataManagerTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/18/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import AmericanChronicle
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

    func testThat_whenStartSearchIsCalled_itStartsAServiceSearch_withTheSameTerm() {
        subject.startSearch("Jibberish", page: 0, completionHandler: { _, _ in })
        XCTAssertEqual(service.startSearch_wasCalled_withTerm, "Jibberish")
    }

    func testThat_whenStartSearchIsCalled_itStartsAServiceSearch_withTheSamePage() {
        subject.startSearch("", page: 11, completionHandler: { _, _ in })
        XCTAssertEqual(service.startSearch_wasCalled_withPage, 11)
    }

    func testThat_whenCancelSearchIsCalled_itCalls_cancelSearch_onTheService_withTheSameTerm() {
        subject.cancelSearch("nonsense", page: 0)
        XCTAssertEqual(service.cancelSearch_wasCalled_withTerm, "nonsense")
    }

    func testThat_whenCancelSearchIsCalled_itCalls_cancelSearch_onTheService_withTheSamePage() {
        subject.cancelSearch("", page: 7)
        XCTAssertEqual(service.cancelSearch_wasCalled_withPage, 7)
    }

    func testThat_whenIsSearchInProgressIsCalled_itCalls_isSearchInProgress_onTheService_withTheSameTerm() {
        subject.isSearchInProgress("blah", page: 0)
        XCTAssertEqual(service.isSearchInProgress_wasCalled_withTerm, "blah")
    }

    func testThat_whenIsSearchInProgressIsCalled_itCallsIsSearchInProgress_onTheService_withTheSamePage() {
        subject.isSearchInProgress("", page: 4)
        XCTAssertEqual(service.isSearchInProgress_wasCalled_withPage, 4)
    }

    func testThat_whenIsSearchInProgressIsCalled_itReturnsTheValueReturnedByCalling_isSearchInProgress_onTheService() {
        service.isSearchInProgress_mock_returnValue = true
        XCTAssert(subject.isSearchInProgress("", page: 0))

    }

    func testThat_whenASearchSucceeds_itCallsTheAssociatedCompletionHandler_withTheSearchResults() {
        var searchResults: SearchResults?
        subject.startSearch("", page: 11, completionHandler: { results, _ in
            searchResults = results
        })
        let mockResults = SearchResults()
        service.startSearch_wasCalled_withCompletionHandler?(mockResults, nil)
        XCTAssertEqual(searchResults, mockResults)
    }

    func testThat_whenASearchFails_itCallsTheAssociatedCompletionHandler_withTheError() {
        var searchError: NSError?
        subject.startSearch("", page: 11, completionHandler: { _, error in
            searchError = error
        })
        let mockError = NSError(domain: "", code: 0, userInfo: nil)
        service.startSearch_wasCalled_withCompletionHandler?(nil, mockError)
        XCTAssertEqual(searchError, mockError)
    }
}
