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

            let navBar = pagesViewController.navigationController?.navigationBar
            let navBarImage = UIScreen.mainScreen().snapshotViewAfterScreenUpdates(false)

            navBarImage.maskView = UIView(frame: CGRect(x: 0, y: 0, width: navBarImage.frame.size.width, height: 64.0))
            navBarImage.maskView?.backgroundColor = UIColor.blackColor()
            var presentingVC: UIViewController? = pagesViewController
            while !(presentingVC?.definesPresentationContext ?? false) {
                presentingVC = presentingVC?.parentViewController
            }
            let navBarCover = UIView(frame: navBarImage.frame)
            navBarCover.backgroundColor = UIColor.blackColor()
            navBarCover.maskView = UIView(frame: CGRect(x: 0, y: 0, width: navBarImage.frame.size.width, height: 64.0))
            navBarCover.maskView?.backgroundColor = UIColor.blackColor()
            pagesViewController.prepareForDisappearanceAnimation()
            pageViewController.prepareForAppearanceAnimation()
            presentingVC?.view.addSubview(navBarCover)
            presentingVC?.view.addSubview(pageViewController.view)
            presentingVC?.view.addSubview(navBarImage)

            UIView.animateWithDuration(2.0, animations: {
                pagesViewController.updateViewsInsideDisappearanceAnimation()
                pageViewController.updateViewsInsideAppearanceAnimation()
                navBarImage.frame = CGRectOffset(navBarImage.frame, 0, -62.0)
            }, completion: { _ in
                navBarImage.removeFromSuperview()
                navBarCover.removeFromSuperview()
                pagesViewController.presentViewController(pageViewController, animated: false, completion: nil)
            })
        }
    }
}

