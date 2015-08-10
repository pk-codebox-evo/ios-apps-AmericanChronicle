//
//  NewspaperPageUnfocusSegue.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/9/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class NewspaperPageUnfocusSegue: UIStoryboardSegue {
    var pagesViewController: NewspaperPagesViewController? {
        return destinationViewController as? NewspaperPagesViewController
    }
    var pageViewController: PageViewController? {
        return sourceViewController as? PageViewController
    }
    override func perform() {
        if let pagesViewController = pagesViewController, let pageViewController = pageViewController {
            pagesViewController.prepareForAppearanceAnimation()
            pageViewController.prepareForDisappearanceAnimation()

            UIView.animateWithDuration(2.0, animations: {
                pagesViewController.updateViewsInsideAppearanceAnimation()
                pageViewController.updateViewsInsideDisappearanceAnimation()
                }, completion: { _ in
                    pagesViewController.dismissViewControllerAnimated(false, completion: nil)
            })
        }
    }
}

