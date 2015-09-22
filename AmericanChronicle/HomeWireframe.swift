//
//  HomeWireframe.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/6/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class HomeWireframe: NSObject {
    var homeViewController: UINavigationController? = {
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let nvc = sb.instantiateInitialViewController() as? UINavigationController
        return nvc
    }()
}
