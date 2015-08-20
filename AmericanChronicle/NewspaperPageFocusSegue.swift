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

    private func imageOfWindow() -> UIImage {
        let window = UIApplication.sharedApplication().keyWindow!
        UIGraphicsBeginImageContext(window.bounds.size)
        window.drawViewHierarchyInRect(window.bounds, afterScreenUpdates: false)
        let fullScreenImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return fullScreenImage
    }

    var navBarCoverView: UIView = {
        let navBarCoverView = UIView()
        navBarCoverView.backgroundColor = UIColor.blackColor()
        return navBarCoverView
    }()

    var fullScreenImageView: UIImageView = {
        return UIImageView()
    }()

    var navBarImageView: UIImageView = {
        let navBarImageView = UIImageView()
        navBarImageView.clipsToBounds = true
        navBarImageView.contentMode = .Top
        return navBarImageView
    }()

    override func perform() {
        if let pagesViewController = pagesViewController, let pageViewController = pageViewController {
            pagesViewController.presentViewController(pageViewController, animated: true, completion: nil)


//            var presentingVC: UIViewController? = pagesViewController
//            while !(presentingVC?.definesPresentationContext ?? false) {
//                presentingVC = presentingVC?.parentViewController
//            }
//
//            println("presentingVC: \(presentingVC)")
//
//            let fullScreenImage = imageOfWindow()
//
//            fullScreenImageView.image = fullScreenImage
//            fullScreenImageView.frame = CGRect(x: 0, y: 0, width: fullScreenImage.size.width, height: fullScreenImage.size.height)
//
//            navBarImageView.image = fullScreenImage
//            navBarImageView.frame = CGRect(x: 0, y: 0, width: fullScreenImage.size.width, height: 64.0)
//
//            pageViewController.prepareForAppearanceAnimation()
//
//            presentingVC?.view.addSubview(fullScreenImageView)
//
//            presentingVC?.view.addSubview(navBarCoverView)
//
//            presentingVC?.view.addSubview(pageViewController.view)
//
//            presentingVC?.view.addSubview(navBarImageView)
//
//            pageViewController.presentingView = fullScreenImageView
//            pageViewController.presentingViewNavBar = navBarImageView
//
//            UIView.animateWithDuration(2.0, animations: {
//                pageViewController.updateViewsInsideAppearanceAnimation()
//                self.navBarImageView.frame = CGRectOffset(self.navBarImageView.frame, 0, -64.0)
//            }, completion: { _ in
//                self.navBarImageView.removeFromSuperview()
//                self.navBarCoverView.removeFromSuperview()
//                self.fullScreenImageView.removeFromSuperview()
//                pagesViewController.presentViewController(pageViewController, animated: false, completion: nil)
//            })
        }
    }
}

