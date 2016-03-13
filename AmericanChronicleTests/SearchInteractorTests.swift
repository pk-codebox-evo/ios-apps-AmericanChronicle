//
//  SearchInteractorTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/6/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import XCTest
@testable import AmericanChronicle

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

    // --- fetchNextPageOfResults(_:) --- //

    func testThat_whenFetchIsCalled_withNewParameters_itAsksTheDataManagerToStartASearchWithTheSameParameters() {
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: SearchConstants.earliestPossibleDayMonthYear,
            latestDayMonthYear: SearchConstants.latestPossibleDayMonthYear
        )
        subject.fetchNextPageOfResults(params)
        XCTAssertEqual(searchFactory.newSearch_wasCalled_withParameters, params)
    }

    func testThat_whenFetchIsCalled_withNewParameters_itCancelsTheLastSearch() {
        let firstParams = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: SearchConstants.earliestPossibleDayMonthYear,
            latestDayMonthYear: SearchConstants.latestPossibleDayMonthYear
        )
        subject.fetchNextPageOfResults(firstParams)
        let firstSearch = searchFactory.newSearchForTerm_lastReturnedSearch

        let secondParams = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado", "New Mexico"],
            earliestDayMonthYear: SearchConstants.earliestPossibleDayMonthYear,
            latestDayMonthYear: SearchConstants.latestPossibleDayMonthYear
        )
        subject.fetchNextPageOfResults(secondParams)
        XCTAssert(firstSearch?.cancel_wasCalled ?? false)
    }

    // * Duplicate parameters
    //    * First search still in progress

    func testThat_whenFetchIsCalled_withDuplicateParameters_andTheFirstSearchIsStillInProgress_itFailsImmediatelyWithADuplicateRequestError() {
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: SearchConstants.earliestPossibleDayMonthYear,
            latestDayMonthYear: SearchConstants.latestPossibleDayMonthYear
        )
        subject.fetchNextPageOfResults(params)
        let firstSearch = searchFactory.newSearchForTerm_lastReturnedSearch
        firstSearch?.isSearchInProgress_returnValue = true

        subject.fetchNextPageOfResults(params)
        XCTAssert(delegate.searchForTerm_didFinish_wasCalled_withError!.isDuplicateRequestError())
    }

    func testThat_whenFetchIsCalled_withDuplicateParameters_andTheFirstSearchIsStillInProgress_itDoesNotCancelTheLastSearch() {
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: SearchConstants.earliestPossibleDayMonthYear,
            latestDayMonthYear: SearchConstants.latestPossibleDayMonthYear
        )
        subject.fetchNextPageOfResults(params)
        let firstSearch = searchFactory.newSearchForTerm_lastReturnedSearch
        firstSearch?.isSearchInProgress_returnValue = true

        subject.fetchNextPageOfResults(params)

        XCTAssertFalse(firstSearch?.cancel_wasCalled ?? true)
    }

    // * Duplicate parameters
    //   * First search has already finished

    func testThat_whenFetchIsCalled_withDuplicateParameters_andTheFirstSearchHasFinished_itAsksTheDataManagerToStartASearchWithTheDuplicateTerm() {
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: SearchConstants.earliestPossibleDayMonthYear,
            latestDayMonthYear: SearchConstants.latestPossibleDayMonthYear
        )

        subject.fetchNextPageOfResults(params)
        let firstSearch = searchFactory.newSearchForTerm_lastReturnedSearch
        firstSearch?.cancel()
        searchFactory.newSearch_wasCalled_withParameters = nil

        subject.fetchNextPageOfResults(params)

        XCTAssertEqual(searchFactory.newSearch_wasCalled_withParameters, params)
    }

    // --- fetchNextPageOfResults(_:) -> (results, error) --- //

    func testThat_whenASearchSucceeds_itPassesTheResultsToItsDelegate() {
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: SearchConstants.earliestPossibleDayMonthYear,
            latestDayMonthYear: SearchConstants.latestPossibleDayMonthYear
        )

        subject.fetchNextPageOfResults(params)
        let results = SearchResults()
        searchFactory.newSearchForTerm_lastReturnedSearch?.finishRequestWithSearchResults(results, error: nil)

        XCTAssertEqual(delegate.searchForTerm_didFinish_wasCalled_withResults, results)
    }

    func testThat_whenASearchFails_itPassesTheErrorToItsDelegate() {
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDayMonthYear: SearchConstants.earliestPossibleDayMonthYear,
            latestDayMonthYear: SearchConstants.latestPossibleDayMonthYear
        )

        subject.fetchNextPageOfResults(params)
        let error = NSError(code: .InvalidParameter, message: "")
        searchFactory.newSearchForTerm_lastReturnedSearch?.finishRequestWithSearchResults(nil, error: error)

        XCTAssertEqual(delegate.searchForTerm_didFinish_wasCalled_withError, error)
    }

    // --- isSearchInProgress() --- //

    func testThat_whenAskedWhetherASearchIsInProgress_itAsksTheActiveSearch() {
        let params = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"], earliestDayMonthYear: SearchConstants.earliestPossibleDayMonthYear, latestDayMonthYear: SearchConstants.latestPossibleDayMonthYear)
        subject.fetchNextPageOfResults(params)
        let search = searchFactory.newSearchForTerm_lastReturnedSearch
        subject.isSearchInProgress()
        XCTAssert(search?.isSearchInProgress_wasCalled ?? false)
    }

    // --- cancelLastSearch() --- //

    func testThat_whenCancelLastSearchIsCalled_itCancelsTheActiveSearch() {
        let params = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"], earliestDayMonthYear: SearchConstants.earliestPossibleDayMonthYear, latestDayMonthYear: SearchConstants.latestPossibleDayMonthYear)
        subject.fetchNextPageOfResults(params)
        let search = searchFactory.newSearchForTerm_lastReturnedSearch
        subject.cancelLastSearch()
        XCTAssert(search?.cancel_wasCalled ?? false)
    }
}
