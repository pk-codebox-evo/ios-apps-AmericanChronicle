//
//  DetailViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    var percentComplete: CGFloat {
        get {
            return focusTransition.percentComplete
        }
        set {
            focusTransition.updateInteractiveTransition(newValue)
        }
    }

    func cancelOrFinish() {
        if percentComplete > 0.5 {
            println("will call finishInteractiveTransition")
            focusTransition.finishInteractiveTransition()
            println("did call finishInteractiveTransition")
        } else {
            println("will call cancelInteractiveTransition")
            focusTransition.cancelInteractiveTransition()
            println("did call cancelInteractiveTransition")
        }
    }

    private var focusTransition = InteractivePageFocusTransition()

    // MARK: UIViewControllerTransitioningDelegate methods

    func animationControllerForPresentedController(
            presented: UIViewController,
            presentingController presenting: UIViewController,
            sourceController source: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
        return focusTransition
    }

    //func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    //}

    func interactionControllerForPresentation(
            animator: UIViewControllerAnimatedTransitioning
        ) -> UIViewControllerInteractiveTransitioning? {

        println("Returning \(focusTransition) as interactionControllerForPresentation")
        return focusTransition
    }
    
//    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//    }

    //func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
    //}
    
}

class InteractivePageFocusTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    let transitionDuration = 2.0
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        println("transitionContext \(transitionContext.description)")
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        if let toView = toView {
            transitionContext.containerView().addSubview(toView)
        }
        UIView.animateWithDuration(transitionDuration, animations: {
            toView?.frame = CGRectOffset(toView?.frame ?? CGRectZero, 200.0, 0)
        }, completion: { finished in
            println("Animation completion block called. Finished? \(finished)")
            println(" * transitionWasCancelled(): \(transitionContext.transitionWasCancelled())")
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }

    func animationEnded(transitionCompleted: Bool) {
        println("animationEnded called. Transition completed? \(transitionCompleted)")
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return transitionDuration
    }
}

//class InteractivePageUnfocusTransition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
//
//}

class NewspaperPagesViewController: UIViewController, UICollectionViewDelegate, NewspaperPagesPreviewActionHandler {

    @IBOutlet weak var previewCollectionView: UICollectionView!
    @IBOutlet weak var stripCollectionView: UICollectionView!
    @IBOutlet var previewDelegate: NewspaperPagesPreviewDelegate!
    @IBOutlet var dataSource: NewspaperPagesDataSource!


    let pageFocusTransitioningDelegate = TransitioningDelegate()

    var issue: NewspaperIssue? {
        didSet {
            if !isViewLoaded() {
                return
            }
            previewDelegate.issue = issue
        }
    }

    func presentPage() {
        let sb = UIStoryboard(name: "Page", bundle: nil)
        if let vc = sb.instantiateInitialViewController() as? PageViewController {
            vc.imageName = issue?.imageName
            vc.transitioningDelegate = pageFocusTransitioningDelegate
            vc.modalTransitionStyle = UIModalTransitionStyle(rawValue: UIModalPresentationStyle.Custom.rawValue)!
            vc.doneCallback = { [weak self] in
                self?.dismissViewControllerAnimated(true, completion: nil)
            }
            println("Will call presentViewController...")
            presentViewController(vc, animated: true, completion: nil)
            println("Did call presentViewController...")
        }
    }

    @IBAction func pinchRecognized(sender: UIPinchGestureRecognizer) {

        switch sender.state {
        case .Possible:
            println("Possible")
        case .Began:
            println("Pinch began")
            presentPage()

        case .Changed:
            println("Changed")
            pageFocusTransitioningDelegate.percentComplete = sender.scale - 1.0
        default: // Ended, Cancelled, Failed
            pageFocusTransitioningDelegate.cancelOrFinish()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        previewDelegate.issue = issue
        previewDelegate.actionHandler = self

        dataSource.issue = issue
        stripCollectionView.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: .Left)
    }


    func didScrollToPreviewAtIndexPath(indexPath: NSIndexPath) {
        stripCollectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .CenteredHorizontally)
    }

    // MARK: UICollectionViewDelegate methods

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        previewCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)

    }

    @IBAction func unfocusPage(sender: UIStoryboardSegue) {
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? PageViewController,
        let selectedPath = previewCollectionView.indexPathsForSelectedItems().first as? NSIndexPath {

            vc.imageName = issue?.pages[selectedPath.item].imageName
            vc.doneCallback = { [unowned self] in

                let segue = NewspaperPageUnfocusSegue(identifier: nil, source: vc, destination: self)
                segue.perform()
            }
        }
    }
}

