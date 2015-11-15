//
//  KeyboardServiceTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 11/14/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import XCTest
import AmericanChronicle


class KeyboardServiceTests: XCTestCase {
    var subject: KeyboardService!
    var notificationCenter: NSNotificationCenter!

    override func setUp() {
        super.setUp()
        notificationCenter = NSNotificationCenter()
        subject = KeyboardService(notificationCenter: notificationCenter)
        subject.applicationDidFinishLaunching()
    }

    private func postKeyboardWillShowNotification(endRect: CGRect) {
        let rectVal = NSValue(CGRect: endRect)
        let userInfo = [UIKeyboardFrameEndUserInfoKey: rectVal]
        notificationCenter.postNotificationName(UIKeyboardWillShowNotification, object: nil, userInfo: userInfo)
    }

    func testThat_whenAKeyboardShows_itUpdatesTheKeyboardFrame() {
        let rect = CGRect(x: 15, y: 15, width: 300, height: 100)
        postKeyboardWillShowNotification(rect)
        XCTAssertEqual(subject.keyboardFrame, rect)
    }

    func testThat_whenTheKeyboardFrameChanges_itCallsEachHandlerWithTheNewFrame() {
        let handlerOneID = "handlerOne"
        var handlerOne_wasCalled_withRect: CGRect?
        let handlerOne = { rect in
            handlerOne_wasCalled_withRect = rect
        }
        subject.addFrameChangeHandler(handlerOneID, handler: handlerOne)

        var handlerTwo_wasCalled_withRect: CGRect?
        let handlerTwo = { rect in
            handlerTwo_wasCalled_withRect = rect
        }
        let handlerTwoID = "handlerTwo"
        subject.addFrameChangeHandler(handlerTwoID, handler: handlerTwo)

        let rect = CGRect(x: 15, y: 15, width: 300, height: 100)
        postKeyboardWillShowNotification(rect)

        XCTAssertEqual(handlerOne_wasCalled_withRect, rect)
        XCTAssertEqual(handlerTwo_wasCalled_withRect, rect)
    }
}