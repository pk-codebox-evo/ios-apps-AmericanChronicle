//
//  SearchWireframe.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/6/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

// MARK: -
// MARK: SearchWireframe class

public class SearchWireframe: NSObject, UIViewControllerTransitioningDelegate {

    let searchPresenter: SearchPresenterProtocol
    let pagePresenter: PagePresenterProtocol

    public init(searchPresenter: SearchPresenterProtocol = SearchPresenter(), pagePresenter: PagePresenterProtocol = PagePresenter()) {
        self.searchPresenter = searchPresenter
        self.pagePresenter = pagePresenter
        super.init()
    }

    public func presentSearchFromViewController(presenting: UIViewController?) {
        let sb = UIStoryboard(name: "Search", bundle: nil)
        if let vc = sb.instantiateInitialViewController() as? SearchViewController {
            searchPresenter.setUpView(vc)
            searchPresenter.cancelCallback = {
                presenting?.dismissViewControllerAnimated(true, completion: nil)
            }
            searchPresenter.showPageCallback = { row in
                self.presentPage(row.pdfURL!, withEstimatedSize: row.estimatedPDFSize, fromViewController: vc)
            }
            let nvc = UINavigationController(rootViewController: vc)
            nvc.modalPresentationStyle = .Custom
            nvc.transitioningDelegate = self
            presenting?.presentViewController(nvc, animated: true, completion: nil)
        }
    }

    // estimatedSize should be in KB
    public func presentPage(url: NSURL, withEstimatedSize estimatedSize: Int, fromViewController presenting: UIViewController?) {
        let sb = UIStoryboard(name: "Page", bundle: nil)
        if let vc = sb.instantiateInitialViewController() as? PageViewController {
            pagePresenter.setUpView(vc, url: url, estimatedSize: estimatedSize)
            pagePresenter.doneCallback = {
                presenting?.dismissViewControllerAnimated(true, completion: nil)
            }

            pagePresenter.shareCallback = {
//                let vc = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
//                vc.completionWithItemsHandler = { type, completed, returnedItems, activityError in
//                    self.toastButton.frame = CGRect(x: 20.0, y: self.bottomBarBG.frame.origin.y - 80.0, width: self.view.bounds.size.width - 40.0, height: 60)
//                    let message: String = ""
//                    if type == nil {
//                        return
//                    }
//                    //            switch type {
//                    //            case UIActivityTypeSaveToCameraRoll:
//                    //                message = completed ? "Page saved successfully" : "Trouble saving, please try again"
//                    //            default:
//                    //                message = completed ? "Success" : "Action failed, please try again"
//                    //            }
//
//                    self.toastButton.setTitle(message, forState: .Normal)
//                    self.toastButton.alpha = 0
//                    self.toastButton.hidden = false
//                    UIView.animateWithDuration(0.2, animations: {
//                        self.toastButton.alpha = 1.0
//                        }, completion: { _ in
//                            UIView.animateWithDuration(0.2, delay: 3.0, options: UIViewAnimationOptions(), animations: {
//                                self.toastButton.alpha = 0
//                                }, completion: { _ in
//                                    self.toastButton.hidden = true
//                            })
//                    })
//                }
//                presentViewController(vc, animated: true, completion: nil)
//            }
//            let nvc = UINavigationController(rootViewController: vc)
//            presenting?.presentViewController(nvc, animated: true, completion: nil)
            }
            presenting?.presentViewController(vc, animated: true, completion: nil)
        }
    }
}

public extension SearchWireframe {
    // MARK: UIViewControllerTransitioningDelegate methods

    public func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ShowSearchTransitionController()
    }

    public func animationControllerForDismissedController(
        dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

            return HideSearchTransitionController()
    }
}

// MARK: -
// MARK: ShowSearchTransitionController class

public class ShowSearchTransitionController: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.1

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        let fromNVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? UINavigationController
        let toNVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? UINavigationController

        if let _ = fromNVC?.topViewController as? HomeViewController  {
            if let toView = transitionContext.viewForKey(UITransitionContextToViewKey) {
                toView.alpha = 0
                transitionContext.containerView()!.addSubview(toView)
                UIView.animateWithDuration(duration, animations: {
                    toView.alpha = 1.0
                }, completion: { _ in
                    if let toVC = toNVC?.topViewController as? SearchViewController {
                        toVC.becomeFirstResponder()
                    }
                    transitionContext.completeTransition(true)
                })
            }
        }
    }

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
}

// MARK: -
// MARK: HideSearchTransitionController class

public class HideSearchTransitionController: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.1

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) {
            UIView.animateWithDuration(duration, animations: {
                fromView.alpha = 0
            }, completion: { _ in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
    }

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
}
