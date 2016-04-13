//
//  DayMonthYearTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 4/13/16.
//  Copyright © 2016 ryanipete. All rights reserved.
//

import XCTest
@testable import AmericanChronicle

class DayMonthYearTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testThat_whenCreatedWithValidComponents_itReturnsTheCorrectUserVisibleString() {
        let subject = DayMonthYear(day: 1, month: 12, year: 1865)
        XCTAssertEqual(subject.userVisibleString, "Dec 01, 1865")
    }
}
