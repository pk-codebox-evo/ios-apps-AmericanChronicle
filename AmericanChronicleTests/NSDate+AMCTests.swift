//
//  NSDate+AMCTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 12/27/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import XCTest
@testable import AmericanChronicle

class NSDate_AMCTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testThatIt_returnsTheCorrectYear_onFirstDayOfYear() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.dateFromString("1903-01-01")
        XCTAssertEqual(date?.year, 1903)
    }

    func testThatIt_returnsTheCorrectYear_onLastDayOfYear() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.dateFromString("2015-12-31")
        XCTAssertEqual(date?.year, 2015)
    }

    func testThatIt_returnsTheCorrectMonth_onFirstDayOfMonth() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.dateFromString("1878-03-01")
        XCTAssertEqual(date?.month, 03)
    }

    func testThatIt_returnsTheCorrectMonth_onLastDayOfMonth() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.dateFromString("1899-11-30")
        XCTAssertEqual(date?.month, 11)
    }
    
}
