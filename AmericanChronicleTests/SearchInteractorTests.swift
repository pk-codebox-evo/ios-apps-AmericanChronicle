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

    // --- startSearch(_, existingRows:) --- //

    // * New parameters
    //     * No existing rows

    func testThat_whenStartSearchIsCalled_withNewParameters_andNoExistingRows_itAsksTheDataManagerToStartASearchWithTheSameParameters() {
        let params = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"])
        subject.startSearch(SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"]), existingRows: [])
        XCTAssertEqual(searchFactory.newSearch_wasCalled_withParameters, params)
    }

    func testThat_whenStartSearchIsCalled_withNewParameters_andNoExistingRows_itAsksTheDataManagerToStartASearchWithTheCorrectPage() {
        let params = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"])
        subject.startSearch(params, existingRows: [])
        XCTAssertEqual(searchFactory.newSearch_wasCalled_withPage, 1)
    }

    // * New parameters
    //   * existingRows % 20 == 0

    func testThat_whenStartSearchIsCalled_withNewParameters_andNumberOfExistingRowsEvenlyDivisibleByPageSize_itAsksTheDataManagerToStartASearchWithTheCorrectPage() {
        let rows = (0..<40).map { _ in
            SearchResultsRow(
                id: "",
                date: nil,
                cityState: "",
                publicationTitle: "",
                thumbnailURL: nil,
                pdfURL: nil,
                lccn: "",
                edition: 0,
                sequence: 0)
        }
        let params = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"])
        subject.startSearch(params, existingRows: rows)
        XCTAssertEqual(searchFactory.newSearch_wasCalled_withPage, 3)
    }

    func testThat_whenStartSearchIsCalled_withNewParameters_andNumberOfExistingRowsEvenlyDivisibleByPageSize_itCancelsTheLastSearch() {
        let firstParams = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"])
        subject.startSearch(firstParams, existingRows: [])
        let firstSearch = searchFactory.newSearchForTerm_lastReturnedSearch
        let secondParams = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado", "New Mexico"])
        subject.startSearch(secondParams, existingRows: [])
        XCTAssert(firstSearch?.cancel_wasCalled ?? false)
    }

    // * New parameters
    //   * existingRows % 20 != 0

    func testThat_whenStartSearchIsCalled_withNewParameters_andNumberOfExistingRowsNotEvenlyDivisibleByPageSize_itFailsImmediatelyWithAnInvalidParameterError() {
        let params = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"])
        let rows = (0..<25).map { _ in
            SearchResultsRow(
                id: "",
                date: nil,
                cityState: "",
                publicationTitle: "",
                thumbnailURL: nil,
                pdfURL: nil,
                lccn: "",
                edition: 0,
                sequence: 0)
        }

        subject.startSearch(params, existingRows: rows)
        XCTAssert(delegate.searchForTerm_didFinish_wasCalled_withError?.isInvalidParameterError() ?? false)
    }

    func testThat_whenStartSearchIsCalled_withNewParameters_andNumberOfExistingRowsNotEvenlyDivisibleByPageSize_itDoesNotCancelTheLastSearch() {
        let firstParams = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"])
        subject.startSearch(firstParams, existingRows: [])
        let firstSearch = searchFactory.newSearchForTerm_lastReturnedSearch
        let rows = (0..<25).map { _ in
            SearchResultsRow(
                id: "",
                date: nil,
                cityState: "",
                publicationTitle: "",
                thumbnailURL: nil,
                pdfURL: nil,
                lccn: "",
                edition: 0,
                sequence: 0)
        }
        let secondParams = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado", "New Mexico"])
        subject.startSearch(secondParams, existingRows: rows)
        XCTAssertFalse(firstSearch?.cancel_wasCalled ?? true)
    }

    // * Duplicate parameters
    //    * First search still in progress

    func testThat_whenStartSearchIsCalled_withDuplicateParameters_andTheFirstSearchIsStillInProgress_itFailsImmediatelyWithADuplicateRequestError() {
        let params = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"])
        subject.startSearch(params, existingRows: [])
        let firstSearch = searchFactory.newSearchForTerm_lastReturnedSearch
        firstSearch?.isSearchInProgress_returnValue = true
        subject.startSearch(params, existingRows: [])
        XCTAssert(delegate.searchForTerm_didFinish_wasCalled_withError!.isDuplicateRequestError() ?? false)
    }

    func testThat_whenStartSearchIsCalled_withDuplicateParameters_andTheFirstSearchIsStillInProgress_itDoesNotCancelTheLastSearch() {
        let params = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"])
        subject.startSearch(params, existingRows: [])
        let firstSearch = searchFactory.newSearchForTerm_lastReturnedSearch
        firstSearch?.isSearchInProgress_returnValue = true
        subject.startSearch(params, existingRows: [])
        XCTAssertFalse(firstSearch?.cancel_wasCalled ?? true)
    }

    // * Duplicate term
    //   * First search has already finished

    func testThat_whenStartSearchIsCalled_withDuplicateParameters_andTheFirstSearchHasFinished_itAsksTheDataManagerToStartASearchWithTheDuplicateTerm() {
        let params = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"])
        subject.startSearch(params, existingRows: [])
        let firstSearch = searchFactory.newSearchForTerm_lastReturnedSearch
        firstSearch?.cancel()
        searchFactory.newSearch_wasCalled_withParameters = nil
        subject.startSearch(params, existingRows: [])

        XCTAssertEqual(searchFactory.newSearch_wasCalled_withParameters, params)
    }

    // --- startSearchForTerm(_, inStates: [], existingRows:) -> (results, error) --- //

    func testThat_whenASearchSucceeds_itPassesTheResultsToItsDelegate() {
        let params = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"])
        subject.startSearch(params, existingRows: [])
        let results = SearchResults()
        searchFactory.newSearchForTerm_lastReturnedSearch?.finishRequestWithSearchResults(results, error: nil)
        XCTAssertEqual(delegate.searchForTerm_didFinish_wasCalled_withResults, results)
    }

    func testThat_whenASearchFails_itPassesTheErrorToItsDelegate() {
        let params = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"])
        subject.startSearch(params, existingRows: [])
        let error = NSError(code: .InvalidParameter, message: "")
        searchFactory.newSearchForTerm_lastReturnedSearch?.finishRequestWithSearchResults(nil, error: error)
        XCTAssertEqual(delegate.searchForTerm_didFinish_wasCalled_withError, error)
    }

    // --- isSearchInProgress() --- //

    func testThat_whenAskedWhetherASearchIsInProgress_itAsksTheActiveSearch() {
        let params = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"])
        subject.startSearch(params, existingRows: [])
        let search = searchFactory.newSearchForTerm_lastReturnedSearch
        subject.isSearchInProgress()
        XCTAssert(search?.isSearchInProgress_wasCalled ?? false)
    }

    // --- cancelLastSearch() --- //

    func testThat_whenCancelLastSearchIsCalled_itCancelsTheActiveSearch() {
        let params = SearchParameters(term: "Jibberish", states: ["Alabama", "Colorado"])
        subject.startSearch(params, existingRows: [])
        let search = searchFactory.newSearchForTerm_lastReturnedSearch
        subject.cancelLastSearch()
        XCTAssert(search?.cancel_wasCalled ?? false)
    }
}
