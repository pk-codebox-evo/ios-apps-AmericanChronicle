//
//  NewspaperPageFocusSegue.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/9/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class NewspaperPageFocusSegue: UIStoryboardSegue {
    var pagesViewController: NewspaperPagesViewController? {
        return sourceViewController as? NewspaperPagesViewController
    }
    var pageViewController: PageViewController? {
        return destinationViewController as? PageViewController
    }
    override func perform() {
        if let pagesViewController = pagesViewController, let pageViewController = pageViewController {

            let window = UIApplication.sharedApplication().keyWindow!
            UIGraphicsBeginImageContext(window.bounds.size)
            window.drawViewHierarchyInRect(window.bounds, afterScreenUpdates: false)
            let fullScreenImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let fullScreenImageView = UIImageView(image: fullScreenImage)

            let navBarImageView = UIImageView(image: fullScreenImage)
            navBarImageView.maskView = UIView(frame: CGRect(x: 0, y: 0, width: fullScreenImage.size.width, height: 64.0))
            navBarImageView.maskView?.backgroundColor = UIColor.blackColor()

            var presentingVC: UIViewController? = pagesViewController
            while !(presentingVC?.definesPresentationContext ?? false) {
                presentingVC = presentingVC?.parentViewController
            }

            let navBarCoverView = UIView(frame: navBarImageView.frame)
            navBarCoverView.backgroundColor = UIColor.blackColor()
            navBarCoverView.maskView = UIView(frame: CGRect(x: 0, y: 0, width: navBarImageView.frame.size.width, height: 64.0))
            navBarCoverView.maskView?.backgroundColor = UIColor.blackColor()

            pageViewController.prepareForAppearanceAnimation()
            presentingVC?.view.addSubview(fullScreenImageView)
            presentingVC?.view.addSubview(navBarCoverView)
            presentingVC?.view.addSubview(pageViewController.view)
            presentingVC?.view.addSubview(navBarImageView)

            pageViewController.presentingView = fullScreenImageView
            pageViewController.presentingViewNavBar = navBarImageView

            UIView.animateWithDuration(2.0, animations: {
                pageViewController.updateViewsInsideAppearanceAnimation()
                navBarImageView.frame = CGRectOffset(navBarImageView.frame, 0, -64.0)
            }, completion: { _ in
                navBarImageView.removeFromSuperview()
                navBarCoverView.removeFromSuperview()
                fullScreenImageView.removeFromSuperview()
                pagesViewController.presentViewController(pageViewController, animated: false, completion: nil)
            })
        }
    }
}

