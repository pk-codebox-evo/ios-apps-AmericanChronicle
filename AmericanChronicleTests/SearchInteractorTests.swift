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

class FakeDelayedSearch: DelayedSearch {

    var didCall_cancel = false
    override func cancel() {
        didCall_cancel = true
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
    func searchForTerm(term: String, page: Int, didFinishWithResults: SearchResults?, error: NSError?) {

    }
}

class SearchInteractorTests: XCTestCase {

    var subject: SearchInteractor!
    var dataManager: FakeSearchDataManager!
    var delegate: FakeSearchInteractorDelegate!

    override func setUp() {
        super.setUp()
        dataManager = FakeSearchDataManager()
        delegate = FakeSearchInteractorDelegate()
        subject = SearchInteractor()
        subject.dataManager = dataManager
        subject.delegate = delegate
    }
//
    func testThat_whenStartSearchIsCalled_itAsksTheDataManagerToStartASearchWithTheSameTerm() {
        subject.startSearch("Jibberish", page: 0)
        XCTAssertEqual(dataManager.startSearch_wasCalled_withTerm, "Jibberish")

    }

    func testThat_whenStartSearchIsCalled_itAsksTheDataManagerToStartASearchWithTheSamePage() {
        subject.startSearch("", page: 5)
        XCTAssertEqual(dataManager.startSearch_wasCalled_withPage, 5)
    }

    func testThat_whenStartSearchIsCalled_itCancelsTheLastSearch_withTheCorrectTerm() {
        subject.startSearch("First Search", page: 3)
        subject.startSearch("Second Search", page: 5)
        XCTAssertEqual(dataManager.cancelSearch_wasCalled_withTerm, "First Search")
    }

    func testThat_whenStartSearchIsCalled_itCancelsTheLastSearch_withTheCorrectPage() {
        subject.startSearch("First Search", page: 3)
        subject.startSearch("Second Search", page: 5)
        XCTAssertEqual(dataManager.cancelSearch_wasCalled_withPage, 3)
    }

    func testThat_whenAskedWhetherASearchIsInProgress_itAsksTheDataManagerWithTheActiveSearchTerm() {
        subject.startSearch("sample search", page: 0)
        subject.isSearchInProgress()
        XCTAssertEqual(dataManager.isSearchInProgress_wasCalled_withTerm, "sample search")
    }

    func testThat_whenAskedWhetherASearchIsInProgress_andThereShouldBeASearchInProgress_itAsksTheDataManagerWithTheActiveTerm() {
        subject.startSearch("sample search", page: 0)
        subject.isSearchInProgress()
        XCTAssertEqual(dataManager.isSearchInProgress_wasCalled_withTerm, "sample search")
    }

    func testThat_whenAskedWhetherASearchIsInProgress_andThereShouldBeASearchInProgress_itAsksTheDataManagerWithTheActivePage() {
        subject.startSearch("", page: 2)
        subject.isSearchInProgress()
        XCTAssertEqual(dataManager.isSearchInProgress_wasCalled_withPage, 2)
    }

    func testThat_whenAskedWhetherASearchIsInProgress_andNoSearchIsActive_itDoesNotBotherTheDataManager() {
        subject.cancelLastSearch()
        XCTAssertFalse(dataManager.isSearchInProgress_wasCalled)
    }

    func testThat_whenASearchIsCancelled_whileASearchIsInProgress_itAsksTheDataManagerToCancelTheSearchWithTheActiveSearchTerm() {
        subject.startSearch("some term", page: 0)
        subject.cancelLastSearch()
        XCTAssertEqual(dataManager.cancelSearch_wasCalled_withTerm, "some term")
    }

    func testThat_whenASearchIsCancelled_whileASearchIsInProgress_itAsksTheDataManagerToCancelTheSearchWithTheActiveSearchPage() {
        subject.startSearch("some term", page: 4)
        subject.cancelLastSearch()
        XCTAssertEqual(dataManager.cancelSearch_wasCalled_withPage, 4)
    }

    func testThat_whenASearchIsCancelled_andNoSearchIsInProgress_itDoesNotAskTheDataManagerToCancelAnyRequests() {
        subject.cancelLastSearch()
        XCTAssertFalse(dataManager.cancelSearch_wasCalled)
    }

    func testThat_whenASearchSucceeds_itPassesTheResultsToItsDelegate() {
        subject.startSearch("", page: 0)
    }

}
