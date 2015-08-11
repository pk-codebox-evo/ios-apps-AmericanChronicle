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
        return NewspaperPageUnfocusSegue(identifier: identifier, source: fromViewController, destination: toViewController)
    }
}
