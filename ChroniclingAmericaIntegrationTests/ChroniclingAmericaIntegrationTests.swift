//
//  ChroniclingAmericaIntegrationTests.swift
//  ChroniclingAmericaIntegrationTests
//
//  Created by Ryan Peterson on 5/27/16.
//  Copyright © 2016 ryanipete. All rights reserved.
//

import XCTest
@testable import AmericanChronicle

class ChroniclingAmericaIntegrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {

        super.tearDown()
    }
    
    func testThat_searchPages_returnsExpectedResults() {
        let expectation = self.expectationWithDescription("Search finished");
        var searchResults: SearchResults?
        let service = SearchPagesService()
        let earliestDayMonthYear = DayMonthYear(day: 1, month: 1, year: 1836)
        let latestDayMonthYear = DayMonthYear(day: 31, month: 12, year: 1846)
        let params = SearchParameters(term: "peterson",
                                      states: ["South Carolina", "Missouri"],
                                      earliestDayMonthYear: earliestDayMonthYear,
                                      latestDayMonthYear: latestDayMonthYear)
        service.startSearch(params, page: 1, contextID: "", completionHandler: { results, error in
            searchResults = results
            expectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(10.0, handler: nil);

        XCTAssertNotNil(searchResults)

        for result in searchResults!.items! {
            XCTAssertGreaterThanOrEqual(result.date!.year, 1836)
            XCTAssertLessThanOrEqual(result.date!.year, 1846)
            XCTAssert(["South Carolina", "Missouri"].contains(result.state!.first!));
        }
        XCTAssertEqual(searchResults?.totalItems, 42)
    }


    
}
