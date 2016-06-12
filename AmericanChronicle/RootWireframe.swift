//
//  HomeWireframe.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/6/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class RootWireframe: NSObject {
    let searchWireframe = SearchWireframe()
    func rootViewController() -> UIViewController? {
        if let vc = searchWireframe.dependencies.view as? SearchViewController {
            return UINavigationController(rootViewController: vc)
        }
        return nil
    }
}
