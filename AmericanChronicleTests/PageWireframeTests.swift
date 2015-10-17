//
//  PageWireframeTests.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/24/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import XCTest
import AmericanChronicle

class PageWireframeTests: XCTestCase {

    var subject: PageWireframe!

    override func setUp() {
        super.setUp()
        subject = PageWireframe(remoteURL: NSURL(string: "http://notreal.com")!)
    }

}
