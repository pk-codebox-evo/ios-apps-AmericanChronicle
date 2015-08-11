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

            var presentingVC: UIViewController? = pagesViewController
            while !(presentingVC?.definesPresentationContext ?? false) {
                presentingVC = presentingVC?.parentViewController
            }

            let navBarImage = pageViewController.presentingViewNavBar

            var navBarFrame = pageViewController.presentingViewNavBar!.frame
            navBarFrame.size.height = 64.0

            let navBarBackgroundView = UIView(frame: navBarFrame)
            navBarBackgroundView.backgroundColor = UIColor.blackColor()

            presentingVC!.view.insertSubview(pageViewController.presentingView!, belowSubview: pageViewController.view!)

            presentingVC!.view.insertSubview(navBarBackgroundView, aboveSubview: pageViewController.presentingView!)
            pageViewController.view.superview!.addSubview(navBarImage!)

            UIView.animateWithDuration(2.0, animations: {
                navBarImage?.frame = CGRectOffset(navBarImage!.frame, 0, 64.0)
                pageViewController.view.alpha = 0
            }, completion: { _ in
                pagesViewController.dismissViewControllerAnimated(false, completion: nil)
                dispatch_async(dispatch_get_main_queue(), {
                    pageViewController.presentingView?.removeFromSuperview()
                    navBarImage?.removeFromSuperview()
                    navBarBackgroundView.removeFromSuperview()
                })
            })
        }
    }
}

