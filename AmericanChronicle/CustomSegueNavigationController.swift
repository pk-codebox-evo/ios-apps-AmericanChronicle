//
//  CustomSegueNavigationController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/9/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class CustomSegueNavigationController: UINavigationController {
    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        println("fromViewController: \(fromViewController)")
        println("toViewController: \(toViewController)")
        println("identifier: \(identifier)")
        let segue = NewspaperPageUnfocusSegue(identifier: identifier, source: fromViewController, destination: toViewController)
        return segue
    }
}
