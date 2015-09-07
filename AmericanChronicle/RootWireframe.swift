//
//  HomeWireframe.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/6/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class RootWireframe: NSObject {
    let homeWireframe = HomeWireframe()
    func rootViewController() -> UIViewController? {
        return homeWireframe.homeViewController
    }
}
