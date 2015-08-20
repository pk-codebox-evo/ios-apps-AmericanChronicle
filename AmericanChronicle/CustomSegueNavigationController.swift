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
        println("toViewController: \(toViewController)")
        println("fromViewController: \(fromViewController)")
        println("identifier: \(identifier)")

        if let fromViewController = fromViewController as? PageViewController {
            return NewspaperPageUnfocusSegue(identifier: identifier, source: fromViewController, destination: toViewController)
        }
        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)
    }
}
