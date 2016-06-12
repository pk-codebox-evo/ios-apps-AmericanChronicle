//
//  SearchWireframe.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/6/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

protocol SearchWireframeInterface: class {
    func userDidSelectSearchResult(row: SearchResultsRow, forTerm: String)
    func userDidTapCancel()
    func showUSStatesPicker(activeStates: [String])
    func userDidTapDayMonthYear(dayMonthYear: DayMonthYear?, title: String?)
    func userDidSaveFilteredUSStates(stateNames: [String])
    func userDidNotSaveFilteredUSStates()
    func userDidSaveDayMonthYear(dayMonthYear: DayMonthYear)
    func userDidNotSaveDate()
}

protocol SearchWireframeDelegate: class {
    func userDidTapCancel()
}

// MARK: -
// MARK: SearchWireframe class

class SearchWireframe: NSObject, SearchWireframeInterface, UIViewControllerTransitioningDelegate {
    let dependencies: SearchModuleDependencies
    var pageWireframe: PageWireframe?
    var statePickerWireframe: USStatePickerWireframe?
    var datePickerWireframe: DatePickerWireframe?
    weak var delegate: SearchWireframeDelegate?
    var showPageHandler: ((NSURL, Int, UIViewController) -> Void)?

    init(dependencies: SearchModuleDependencies = SearchModuleDependencies()) {
        self.dependencies = dependencies
        super.init()
        dependencies.presenter.wireframe = self
    }

    func presentSearchFromViewController(presenting: UIViewController?) {
        if let vc = dependencies.view as? SearchViewController {
            let nvc = UINavigationController(rootViewController: vc)
            nvc.modalPresentationStyle = .Custom
            nvc.transitioningDelegate = self
            presenting?.presentViewController(nvc, animated: true, completion: nil)
        }
    }

    func userDidTapCancel() {
        delegate?.userDidTapCancel()
    }

    func userDidSelectSearchResult(row: SearchResultsRow, forTerm term: String) {
        if let remoteURL = row.pdfURL, id = row.id {
            pageWireframe = PageWireframe(remoteURL: remoteURL, id: id, searchTerm: term, date: row.date, lccn: row.lccn, edition: row.edition, sequence: row.sequence)
            pageWireframe?.beginFromViewController(dependencies.view as? SearchViewController, withRemoteURL: remoteURL)
        }
    }

    func showUSStatesPicker(selectedStates: [String]) {
        statePickerWireframe = USStatePickerWireframe(parentWireframe: self)
        statePickerWireframe?.beginFromViewController(dependencies.view as? SearchViewController, selectedStateNames: selectedStates)
    }

    func userDidSaveFilteredUSStates(stateNames: [String]) {
        dependencies.presenter.userDidSaveFilteredUSStates(stateNames)
        statePickerWireframe?.finish()
    }

    func userDidNotSaveFilteredUSStates() {
        statePickerWireframe?.finish()
    }

    func userDidTapDayMonthYear(dayMonthYear: DayMonthYear?, title: String?) {
        datePickerWireframe = DatePickerWireframe(parentWireframe: self)
        datePickerWireframe?.beginFromViewController(dependencies.view as? SearchViewController, dayMonthYear: dayMonthYear, title: title)
    }

    func userDidSaveDayMonthYear(dayMonthYear: DayMonthYear) {
        dependencies.presenter.userDidSaveDayMonthYear(dayMonthYear)
        datePickerWireframe?.finish()
    }

    func userDidNotSaveDate() {
        datePickerWireframe?.finish()
    }
}

// MARK: -
// MARK: SearchWireframe (UIViewControllerTransitioningDelegate)

extension SearchWireframe {
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ShowSearchTransitionController()
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HideSearchTransitionController()
    }
}

// MARK: -
// MARK: ShowSearchTransitionController

class ShowSearchTransitionController: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.1

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

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

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
}

// MARK: -
// MARK: HideSearchTransitionController class

class HideSearchTransitionController: NSObject, UIViewControllerAnimatedTransitioning {

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
