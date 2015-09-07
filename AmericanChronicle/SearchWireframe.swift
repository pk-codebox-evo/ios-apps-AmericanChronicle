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

    public init(searchPresenter: SearchPresenterProtocol = SearchPresenter()) {
        self.searchPresenter = searchPresenter
        super.init()
    }

    public func presentSearchFromViewController(presenting: UIViewController?) {
        let sb = UIStoryboard(name: "Search", bundle: nil)
        if let vc = sb.instantiateInitialViewController() as? SearchViewController {
            searchPresenter.setUpView(vc)
            searchPresenter.cancelCallback = {
                presenting?.dismissViewControllerAnimated(true, completion: nil)
            }
            let nvc = UINavigationController(rootViewController: vc)
            nvc.modalPresentationStyle = .Custom
            nvc.transitioningDelegate = self
            presenting?.presentViewController(nvc, animated: true, completion: nil)
        }
    }

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
