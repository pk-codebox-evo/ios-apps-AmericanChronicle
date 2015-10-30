//
//  SearchWireframeTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/7/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import XCTest
import AmericanChronicle

class SearchWireframeTests: XCTestCase {

    var subject: SearchWireframe!
    var fakePresenter: FakeSearchPresenter!

    override func setUp() {
        super.setUp()
        fakePresenter = FakeSearchPresenter()
        subject = SearchWireframe()
    }

    func testThat_whenAskedToPresentSearch_itPresentsItsView_wrappedInANavigationController() {
        let presenting = FakeViewController()
        subject.presentSearchFromViewController(presenting)
        let nvc = presenting.didCall_presentViewController_withViewController as! UINavigationController
        XCTAssertTrue(nvc.topViewController is SearchViewController)
    }

    func testThat_whenPresentingTheSearchViewController_itReturnsTheCorrectTransitionType() {
        let transition = subject.animationControllerForPresentedController(
                            UIViewController(),
                            presentingController: UIViewController(),
                            sourceController: UIViewController())
        XCTAssertTrue(transition is ShowSearchTransitionController)
    }
    func testThat_whenDismissingTheSearchViewController_itReturnsTheCorrectTransitionType() {
        let transition = subject.animationControllerForDismissedController(UIViewController())
        XCTAssertTrue(transition is HideSearchTransitionController)
    }
}
