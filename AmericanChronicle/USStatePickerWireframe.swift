//
//  USStatePickerWireframe.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 12/11/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import UIKit

// MARK: -
// MARK: USStatePickerWireframeInterface class

protocol USStatePickerWireframeInterface: class {
    func beginFromViewController(parentModuleViewController: UIViewController?, selectedStateNames: [String])
    func userDidTapSave(selectedItems: [String])
    func userDidTapCancel()
    func finish()
}

// MARK: -
// MARK: USStatePickerWireframeDelegate class

protocol USStatePickerWireframeDelegate: class {
}

// MARK: -
// MARK: USStatePickerWireframe class

class USStatePickerWireframe: NSObject, USStatePickerWireframeInterface {

    let parentWireframe: SearchWireframeInterface
    let view: USStatePickerViewInterface
    let interactor: USStatePickerInteractorInterface
    let presenter: USStatePickerPresenterInterface

    internal init(
        parentWireframe: SearchWireframeInterface,
        view: USStatePickerViewInterface = USStatePickerViewController(),
        interactor: USStatePickerInteractorInterface = USStatePickerInteractor(),
        presenter: USStatePickerPresenterInterface = USStatePickerPresenter())
    {
        self.parentWireframe = parentWireframe
        self.view = view
        self.interactor = interactor
        self.presenter = presenter

        super.init()

        self.view.delegate = self.presenter
        self.presenter.view = self.view
        self.presenter.interactor = self.interactor
        self.presenter.wireframe = self
    }

    func beginFromViewController(parentModuleViewController: UIViewController?, selectedStateNames: [String]) {
        if let vc = view as? USStatePickerViewController {
            let nvc = UINavigationController(rootViewController: vc)
            nvc.modalPresentationStyle = .Custom
            nvc.transitioningDelegate = self
            parentModuleViewController?.presentViewController(nvc, animated: true, completion: nil)
            presenter.begin(selectedStateNames)
        }
    }

    func finish() {
        if let vc = view as? USStatePickerViewController, presenting = vc.presentingViewController {
            presenting.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func userDidTapSave(selectedItems: [String]) {
        parentWireframe.userDidSaveFilteredUSStates(selectedItems)
    }

    func userDidTapCancel() {
        parentWireframe.userDidNotSaveFilteredUSStates()
    }
}

// MARK: -
// MARK: SearchWireframe (UIViewControllerTransitioningDelegate)

extension USStatePickerWireframe: UIViewControllerTransitioningDelegate {
    internal func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return ShowUSStatePickerTransitionController()
    }

    internal func animationControllerForDismissedController(
        dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return HideUSStatePickerTransitionController()
    }
}

// MARK: -
// MARK: ShowSearchTransitionController

class ShowUSStatePickerTransitionController: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.1

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        let fromNVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? UINavigationController

        if let _ = fromNVC?.topViewController as? SearchViewController  {
            if let toView = transitionContext.viewForKey(UITransitionContextToViewKey) {
                toView.alpha = 0
                transitionContext.containerView()!.addSubview(toView)
                UIView.animateWithDuration(duration, animations: {
                    toView.alpha = 1.0
                    }, completion: { _ in
                        transitionContext.completeTransition(true)
                })
            }
        }
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
}

// MARK: -
// MARK: HideSearchTransitionController class

class HideUSStatePickerTransitionController: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.1

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) {
            UIView.animateWithDuration(duration, animations: {
                fromView.alpha = 0
                }, completion: { _ in
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
        }
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
}