//
//  SearchInteractorTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/6/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import XCTest
import AmericanChronicle

class FakeDelayedSearch: DelayedSearchInterface {
    private let completionHandler: ((SearchResults?, ErrorType?) -> ())
    required init(term: String, page: Int, dataManager: SearchDataManagerInterface, completionHandler: ((SearchResults?, ErrorType?) -> ())) {
        self.completionHandler = completionHandler
    }
    var cancel_wasCalled = false
    func cancel() {
        cancel_wasCalled = true
    }

    var isSearchInProgress_wasCalled = false
    func isSearchInProgress() -> Bool {
        isSearchInProgress_wasCalled = true
        return false
    }

    func finishRequestWithSearchResults(results: SearchResults?, error: ErrorType?) {
        completionHandler(results, error)
    }
}

class FakeSearchDataManager: SearchDataManagerInterface {

    var service: SearchPagesServiceInterface?

    var startSearch_wasCalled_withTerm: String?
    var startSearch_wasCalled_withPage: Int?
    func startSearch(term: String, page: Int, completionHandler: ((SearchResults?, NSError?) -> Void)) {
        startSearch_wasCalled_withTerm = term
        startSearch_wasCalled_withPage = page
    }

    var cancelSearch_wasCalled = false
    var cancelSearch_wasCalled_withTerm: String?
    var cancelSearch_wasCalled_withPage: Int?
    func cancelSearch(term: String, page: Int) {
        cancelSearch_wasCalled = true
        cancelSearch_wasCalled_withTerm = term
        cancelSearch_wasCalled_withPage = page
    }

    var isSearchInProgress_wasCalled = false
    var isSearchInProgress_wasCalled_withTerm: String?
    var isSearchInProgress_wasCalled_withPage: Int?
    func isSearchInProgress(term: String, page: Int) -> Bool {
        isSearchInProgress_wasCalled = true
        isSearchInProgress_wasCalled_withTerm = term
        isSearchInProgress_wasCalled_withPage = page
        return false
    }
}

class FakeSearchInteractorDelegate: SearchInteractorDelegate {
    var searchForTerm_didFinish_wasCalled = false
    var searchForTerm_didFinish_wasCalled_withResults: SearchResults?
    var searchForTerm_didFinish_wasCalled_withError: NSError?
    func searchForTerm(term: String, page: Int, didFinishWithResults results: SearchResults?, error: NSError?) {
        searchForTerm_didFinish_wasCalled = true
        searchForTerm_didFinish_wasCalled_withResults = results
        searchForTerm_didFinish_wasCalled_withError = error
    }
}

class FakeDelayedSearchFactory: DelayedSearchFactoryInterface {
    var newSearchForTerm_wasCalled_withTerm: String?
    var newSearchForTerm_wasCalled_withPage: Int?
    private(set) var newSearchForTerm_lastReturnedSearch: FakeDelayedSearch?

    func newSearchForTerm(term: String, page: Int, callback: ((SearchResults?, ErrorType?) -> ())) -> DelayedSearchInterface? {
        newSearchForTerm_wasCalled_withTerm = term
        newSearchForTerm_wasCalled_withPage = page
        newSearchForTerm_lastReturnedSearch = FakeDelayedSearch(term: term, page: page, dataManager: FakeSearchDataManager(), completionHandler: callback)
        return newSearchForTerm_lastReturnedSearch
    }

    init() {}
}

class SearchInteractorTests: XCTestCase {

    var subject: SearchInteractor!
    var searchFactory: FakeDelayedSearchFactory!
    var delegate: FakeSearchInteractorDelegate!

    override func setUp() {
        super.setUp()
        searchFactory = FakeDelayedSearchFactory()
        delegate = FakeSearchInteractorDelegate()
        subject = SearchInteractor(searchFactory: searchFactory)
        subject.delegate = delegate
    }

    func testThat_whenStartSearchIsCalled_itAsksTheDataManagerToStartASearchWithTheSameTerm() {
        subject.startSearch("Jibberish", page: 0)
        XCTAssertEqual(searchFactory.newSearchForTerm_wasCalled_withTerm, "Jibberish")

    }

    func testThat_whenStartSearchIsCalled_itAsksTheDataManagerToStartASearchWithTheSamePage() {
        subject.startSearch("", page: 5)
        XCTAssertEqual(searchFactory.newSearchForTerm_wasCalled_withPage, 5)
    }

    func testThat_whenStartSearchIsCalled_itCancelsTheLastSearch() {
        subject.startSearch("First Search", page: 3)
        let firstSearch = searchFactory.newSearchForTerm_lastReturnedSearch
        subject.startSearch("Second Search", page: 5)
        XCTAssert(firstSearch?.cancel_wasCalled ?? false)
    }

    func testThat_whenAskedWhetherASearchIsInProgress_itAsksTheActiveSearch() {
        subject.startSearch("sample search", page: 0)
        let search = searchFactory.newSearchForTerm_lastReturnedSearch
        subject.isSearchInProgress()
        XCTAssert(search?.isSearchInProgress_wasCalled ?? false)
    }

    func testThat_whenCancelLastSearchIsCalled_itCancelsTheActiveSearch() {

        subject.startSearch("some term", page: 0)
        let search = searchFactory.newSearchForTerm_lastReturnedSearch
        subject.cancelLastSearch()
        XCTAssert(search?.cancel_wasCalled ?? false)
    }

    func testThat_whenASearchSucceeds_itPassesTheResultsToItsDelegate() {
        subject.startSearch("", page: 0)
        let results = SearchResults()
        searchFactory.newSearchForTerm_lastReturnedSearch?.finishRequestWithSearchResults(results, error: nil)
        XCTAssertEqual(delegate.searchForTerm_didFinish_wasCalled_withResults, results)
    }

    func testThat_whenASearchFails_itPassesTheErrorToItsDelegate() {
        subject.startSearch("", page: 0)
        let error = NSError(code: .InvalidParameter)
        searchFactory.newSearchForTerm_lastReturnedSearch?.finishRequestWithSearchResults(nil, error: error)
        XCTAssertEqual(delegate.searchForTerm_didFinish_wasCalled_withError, error)
    }

}
