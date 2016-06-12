//
//  DatePickerWireframe.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 12/20/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import UIKit

// MARK: -
// MARK: DatePickerWireframeInterface class

protocol DatePickerWireframeInterface: class {
    func beginFromViewController(parentModuleViewController: UIViewController?, dayMonthYear: DayMonthYear?, title: String?)
    func userDidTapSave(dayMonthYear: DayMonthYear)
    func userDidTapCancel()
    func finish()
}

// MARK: -
// MARK: DatePickerWireframeDelegate class

protocol DatePickerWireframeDelegate: class {
}

// MARK: -
// MARK: DatePickerWireframe class

class DatePickerWireframe: NSObject, DatePickerWireframeInterface {

    let parentWireframe: SearchWireframeInterface
    let view: DatePickerViewInterface
    let interactor: DatePickerInteractorInterface
    let presenter: DatePickerPresenterInterface

    internal init(
        parentWireframe: SearchWireframeInterface,
        view: DatePickerViewInterface = DatePickerViewController(),
        interactor: DatePickerInteractorInterface = DatePickerInteractor(),
        presenter: DatePickerPresenterInterface = DatePickerPresenter())
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

    func beginFromViewController(parentModuleViewController: UIViewController?, dayMonthYear: DayMonthYear?, title: String?) {
        if let vc = view as? DatePickerViewController {
            vc.title = title
            vc.modalPresentationStyle = .Custom
            vc.transitioningDelegate = self
            parentModuleViewController?.presentViewController(vc, animated: true, completion: nil)
            presenter.beginWithSelectedDayMonthYear(dayMonthYear)
        }
    }

    func finish() {
        if let vc = view as? DatePickerViewController, presenting = vc.presentingViewController {
            presenting.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func userDidTapSave(dayMonthYear: DayMonthYear) {
        parentWireframe.userDidSaveDayMonthYear(dayMonthYear)
    }

    func userDidTapCancel() {
        parentWireframe.userDidNotSaveDate()
    }
}

// MARK: -
// MARK: SearchWireframe (UIViewControllerTransitioningDelegate)

extension DatePickerWireframe: UIViewControllerTransitioningDelegate {
    internal func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return ShowDatePickerTransitionController()
    }

    internal func animationControllerForDismissedController(
        dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return HideDatePickerTransitionController()
    }
}

// MARK: -
// MARK: ShowSearchTransitionController

class ShowDatePickerTransitionController: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.1

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

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

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
}

// MARK: -
// MARK: HideSearchTransitionController class

class HideDatePickerTransitionController: NSObject, UIViewControllerAnimatedTransitioning {

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