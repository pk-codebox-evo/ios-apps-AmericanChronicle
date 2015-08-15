//
//  YearSliderTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/15/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import XCTest
import AmericanChronicle

class YearSliderTests: XCTestCase {

    var subject: YearSlider!

    override func setUp() {
        super.setUp()
        subject = YearSlider()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testThat_after_init_value_isEqualTo_0() {
        XCTAssertEqual(subject.value, 0)
    }

    func testThat_after_init_minValue_isEqualTo_0() {
        XCTAssertEqual(subject.minValue, 0)
    }

    func testThat_after_init_maxValue_isEqualTo_0() {
        XCTAssertEqual(subject.maxValue, 0)
    }

    func testThat_after_settingValueGreaterThanMaxValue_value_isEqualTo_maxValue() {
        subject.maxValue = 10
        subject.value = 11
        XCTAssertEqual(subject.value, subject.maxValue)
    }
}
