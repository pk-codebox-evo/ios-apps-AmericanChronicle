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
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testThat_after_init_value_isEqualTo_0() {
        XCTAssertEqual(subject.value, 0)
    }

    func testThat_after_init_minValue_isEqualTo_0() {
        XCTAssertEqual(subject.minValue, 0)
    }

    func testThat_after_init_maxValue_isEqualTo_1() {
        XCTAssertEqual(subject.maxValue, 1)
    }

    func testThat_after_settingValueGreaterThanMaxValue_value_isEqualTo_maxValue() {
        subject.maxValue = 10
        subject.value = 11
        XCTAssertEqual(subject.value, subject.maxValue)
    }
}
