//
//  FakeSearchWireframe.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 11/8/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import AmericanChronicle

class FakeSearchWireframe: SearchWireframe {
    var userDidTapCancel_wasCalled = false
    override func userDidTapCancel() {
        userDidTapCancel_wasCalled = true
    }
}
