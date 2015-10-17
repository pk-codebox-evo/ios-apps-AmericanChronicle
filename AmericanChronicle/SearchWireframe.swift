//
//  SearchWireframe.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/6/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

public protocol SearchWireframeInterface: class {
    func userDidSelectSearchResult(row: SearchResultsRow)
    func userDidTapCancel()
}

public protocol SearchWireframeDelegate: class {
    func userDidTapCancel()
}

// MARK: -
// MARK: SearchWireframe class

public class SearchWireframe: NSObject, SearchWireframeInterface, UIViewControllerTransitioningDelegate {
    let dependencies: SearchModuleDependencies
    var pageWireframe: PageWireframe?
    weak var delegate: SearchWireframeDelegate?
    var showPageHandler: ((NSURL, Int, UIViewController) -> Void)?

    public init(
        dependencies: SearchModuleDependencies = SearchModuleDependencies())
    {
        self.dependencies = dependencies
        super.init()
        dependencies.presenter.wireframe = self
    }

    public func presentSearchFromViewController(presenting: UIViewController?) {
        if let vc = dependencies.view as? SearchViewController {
            let nvc = UINavigationController(rootViewController: vc)
            nvc.modalPresentationStyle = .Custom
            nvc.transitioningDelegate = self
            presenting?.presentViewController(nvc, animated: true, completion: nil)
        }
    }

    public func userDidTapCancel() {
        delegate?.userDidTapCancel()
    }

    public func userDidSelectSearchResult(row: SearchResultsRow) {
        if let remoteURL = row.pdfURL {
            pageWireframe = PageWireframe(remoteURL: remoteURL)
            pageWireframe?.beginFromViewController(dependencies.view as? SearchViewController, withRemoteURL: remoteURL)
        }
    }
}

// MARK: -
// MARK: SearchWireframe (UIViewControllerTransitioningDelegate)

public extension SearchWireframe {
    public func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ShowSearchTransitionController()
    }

    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HideSearchTransitionController()
    }
}

// MARK: -
// MARK: ShowSearchTransitionController

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
