//
//  SearchDataManagerTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/18/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

@testable import AmericanChronicle
import XCTest

class FakeCachedSearchResultsService: CachedSearchResultsServiceInterface {
    var resultsForParameters_stubbedReturnValue: SearchResults?
    func resultsForParameters(parameters: SearchParameters) -> SearchResults? {
        return resultsForParameters_stubbedReturnValue
    }
    func cacheResults(results: SearchResults, forParameters parameters: SearchParameters) {

    }
}

class SearchDataManagerTests: XCTestCase {

    var webService: FakeSearchPagesService!
    var cacheService: FakeCachedSearchResultsService!
    var subject: SearchDataManager!

    override func setUp() {
        super.setUp()
        webService = FakeSearchPagesService()
        cacheService = FakeCachedSearchResultsService()
        subject = SearchDataManager(webService: webService, cacheService: cacheService)
    }

    func testThat_whenFetchMoreResultsIsCalled_itStartsAServiceSearch_withTheSameParameters() {
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDate: SearchConstants.earliestPossibleDate(),
            latestDate: SearchConstants.latestPossibleDate()
        )
        subject.fetchMoreResults(params, completionHandler: { _, _ in })
        XCTAssertEqual(webService.startSearch_wasCalled_withParameters, params)
    }

    func testThat_whenFetchMoreResultsIsCalled_andNoResultsHaveBeenCached_itStartsAServiceSearch_forTheFirstPage() {
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDate: SearchConstants.earliestPossibleDate(),
            latestDate: SearchConstants.latestPossibleDate()
        )
        cacheService.resultsForParameters_stubbedReturnValue = nil
        subject.fetchMoreResults(params, completionHandler: { _, _ in })
        XCTAssertEqual(webService.startSearch_wasCalled_withPage, 1)
    }

    func testThat_whenFetchMoreResultsIsCalled_andResultsHaveBeenCached_andMorePagesAreAvailable_itStartsAServiceSearch_forTheNextPage() {
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDate: SearchConstants.earliestPossibleDate(),
            latestDate: SearchConstants.latestPossibleDate()
        )
        cacheService.resultsForParameters_stubbedReturnValue = searchResultsWithItemCount(40, totalItemCount: 50)
        subject.fetchMoreResults(params, completionHandler: { _, _ in })
        XCTAssertEqual(webService.startSearch_wasCalled_withPage, 3)
    }

    func testThat_whenFetchMoreResultsIsCalled_andResultsHaveBeenCached_andNoMorePagesAreAvailable_itFailsImmediately_withAnInvalidParameterError() {
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDate: SearchConstants.earliestPossibleDate(),
            latestDate: SearchConstants.latestPossibleDate()
        )
        cacheService.resultsForParameters_stubbedReturnValue = searchResultsWithItemCount(50, totalItemCount: 50)
        var returnedError: NSError?
        subject.fetchMoreResults(params, completionHandler: { _, error in
            returnedError = error
        })
        XCTAssert(returnedError!.isAllItemsLoadedError())
    }



    func testThat_whenFetchMoreResultsIsCalled_andResultsHaveBeenCached_andNoMorePagesAreAvailable_itDoesNotMakeARequest() {
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDate: SearchConstants.earliestPossibleDate(),
            latestDate: SearchConstants.latestPossibleDate()
        )
        cacheService.resultsForParameters_stubbedReturnValue = searchResultsWithItemCount(50, totalItemCount: 50)
        subject.fetchMoreResults(params, completionHandler: { _, _ in })
        XCTAssertNil(webService.startSearch_wasCalled_withParameters)
    }

    func testThat_whenCancelFetchIsCalled_itCalls_cancelSearch_onTheWebService_withTheSameParameters() {
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDate: SearchConstants.earliestPossibleDate(),
            latestDate: SearchConstants.latestPossibleDate()
        )
        subject.cancelFetch(params)
        XCTAssertEqual(webService.cancelSearch_wasCalled_withParameters, params)
    }

    func testThat_whenCancelFetchIsCalled_andNoResultsAreCached_itCancelsTheWebServiceRequest_forTheFirstPage() {
        cacheService.resultsForParameters_stubbedReturnValue = nil
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDate: SearchConstants.earliestPossibleDate(),
            latestDate: SearchConstants.latestPossibleDate()
        )
        subject.cancelFetch(params)
        XCTAssertEqual(webService.cancelSearch_wasCalled_withPage, 1)
    }

    func testThat_whenCancelFetchIsCalled_andResultsAreCached_itCancelsTheWebServiceRequest_forTheNextPage() {
        cacheService.resultsForParameters_stubbedReturnValue = searchResultsWithItemCount(40, totalItemCount: 50)
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDate: SearchConstants.earliestPossibleDate(),
            latestDate: SearchConstants.latestPossibleDate()
        )

        subject.cancelFetch(params)
        XCTAssertEqual(webService.cancelSearch_wasCalled_withPage, 3)
    }

    func testThat_whenIsFetchInProgressIsCalled_itCalls_isSearchInProgress_onTheService_withTheSameParameters() {
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDate: SearchConstants.earliestPossibleDate(),
            latestDate: SearchConstants.latestPossibleDate()
        )
        subject.isFetchInProgress(params)
        XCTAssertEqual(webService.isSearchInProgress_wasCalled_withParameters, params)
    }

    func testThat_whenIsFetchInProgressIsCalled_andNoResultsAreCached_itCalls_isSearchInProgress_onTheService_withTheFirstPage() {
        cacheService.resultsForParameters_stubbedReturnValue = nil
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDate: SearchConstants.earliestPossibleDate(),
            latestDate: SearchConstants.latestPossibleDate()
        )
        subject.isFetchInProgress(params)
        XCTAssertEqual(webService.isSearchInProgress_wasCalled_withPage, 1)
    }

    func testThat_whenIsFetchInProgressIsCalled_andResultsAreCached_itCalls_isSearchInProgress_onTheService_withTheNextPage() {
        cacheService.resultsForParameters_stubbedReturnValue = searchResultsWithItemCount(40, totalItemCount: 50)
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDate: SearchConstants.earliestPossibleDate(),
            latestDate: SearchConstants.latestPossibleDate()
        )
        subject.isFetchInProgress(params)
        XCTAssertEqual(webService.isSearchInProgress_wasCalled_withPage, 3)
    }

    func testThat_whenIsFetchInProgressIsCalled_itReturnsTheValueReturnedByCalling_isSearchInProgress_onTheService() {
        webService.isSearchInProgress_mock_returnValue = true
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDate: SearchConstants.earliestPossibleDate(),
            latestDate: SearchConstants.latestPossibleDate()
        )
        XCTAssert(subject.isFetchInProgress(params))
    }

    func testThat_whenASearchSucceeds_itCallsTheAssociatedCompletionHandler_withTheSearchResults() {
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDate: SearchConstants.earliestPossibleDate(),
            latestDate: SearchConstants.latestPossibleDate()
        )
        var searchResults: SearchResults?
        subject.fetchMoreResults(params, completionHandler: { results, _ in
            searchResults = results
        })
        let mockResults = SearchResults()
        webService.startSearch_wasCalled_withCompletionHandler?(mockResults, nil)
        XCTAssertEqual(searchResults, mockResults)
    }

    func testThat_whenASearchFails_itCallsTheAssociatedCompletionHandler_withTheError() {
        let params = SearchParameters(
            term: "Jibberish",
            states: ["Alabama", "Colorado"],
            earliestDate: SearchConstants.earliestPossibleDate(),
            latestDate: SearchConstants.latestPossibleDate()
        )
        var searchError: NSError?
        subject.fetchMoreResults(params, completionHandler: { _, error in
            searchError = error
        })
        let mockError = NSError(domain: "", code: 0, userInfo: nil)
        webService.startSearch_wasCalled_withCompletionHandler?(nil, mockError)
        XCTAssertEqual(searchError, mockError)
    }

    // Helpers

    func searchResultsWithItemCount(itemCount: Int, totalItemCount: Int) -> SearchResults {
        let results = SearchResults()
        results.totalItems = totalItemCount
        results.itemsPerPage = 20
        results.items = (0..<itemCount).map { _ in SearchResult() }
        return results
    }
}
