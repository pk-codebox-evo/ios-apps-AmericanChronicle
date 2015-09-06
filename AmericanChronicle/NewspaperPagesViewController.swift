//
//  DetailViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

extension UIView {
    func addForAutolayout(subview: UIView) {
        subview.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(subview)
    }
}

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

    override func updateInteractiveTransition(percentComplete: CGFloat) {
        super.updateInteractiveTransition(percentComplete)
        if percentComplete >= 1.0 {
            finishInteractiveTransition()
        }
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
        let v = UIImageView()
        v.setTranslatesAutoresizingMaskIntoConstraints(false)
        return v
    }()

    var navBarImageView: UIImageView = {
        let navBarImageView = UIImageView()
        navBarImageView.clipsToBounds = true
        navBarImageView.contentMode = .Top
        return navBarImageView
        }()

    let transitionDuration = 2.0
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        println("transitionContext \(transitionContext.description)")
        println(" * containerView(): \(transitionContext.containerView())")
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        println(" * viewForKey(UITransitionContextFromViewKey): \(fromView)")
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        println(" * viewForKey(UITransitionContextToViewKey): \(toView)")
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        println(" * viewControllerForKey(UITransitionContextFromViewControllerKey): \(fromVC)")
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        println(" * viewControllerForKey(UITransitionContextToViewControllerKey): \(toVC)")

        let fullScreenImage = imageOfWindow()

        fullScreenImageView.image = fullScreenImage
        transitionContext.containerView().addForAutolayout(fullScreenImageView)
        fullScreenImageView.snp_makeConstraints { make in
             make.top.equalTo(0)
             make.bottom.equalTo(0)
             make.leading.equalTo(0)
             make.trailing.equalTo(0)
        }

        transitionContext.containerView().addForAutolayout(navBarCoverView) // Cover the real navBar
        navBarCoverView.snp_makeConstraints { make in
             make.top.equalTo(0)
             make.leading.equalTo(0)
             make.trailing.equalTo(0)
             make.height.equalTo(64.0)
        }

        navBarImageView.image = fullScreenImage
        transitionContext.containerView().addForAutolayout(navBarImageView)
        navBarImageView.snp_makeConstraints { make in
             make.top.equalTo(0)
             make.leading.equalTo(0)
             make.trailing.equalTo(0)
             make.height.equalTo(64.0)
        }
        navBarImageView.layoutIfNeeded()

        let stripCoverView = UIView()
        stripCoverView.backgroundColor = UIColor.blackColor()
        transitionContext.containerView().addForAutolayout(stripCoverView)
        stripCoverView.snp_makeConstraints { make in
            make.bottom.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(100.0)
        }

        let stripImageView = UIImageView()
        stripImageView.image = fullScreenImage
        stripImageView.clipsToBounds = true
        stripImageView.contentMode = .Bottom
        transitionContext.containerView().addForAutolayout(stripImageView)
        stripImageView.snp_makeConstraints { make in
            make.bottom.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(100.0)
        }
        stripImageView.layoutIfNeeded()

        navBarImageView.snp_updateConstraints { make in
            make.top.equalTo(-64.0)
        }

        stripImageView.snp_updateConstraints { make in
             make.bottom.equalTo(100.0)
        }


        UIView.animateWithDuration(transitionDuration, animations: {
            self.navBarImageView.layoutIfNeeded()
            stripImageView.layoutIfNeeded()
        }, completion: { finished in
            println("Animation completion block called. Finished? \(finished)")
            println(" * transitionWasCancelled(): \(transitionContext.transitionWasCancelled())")
            self.fullScreenImageView.removeFromSuperview()
            self.navBarCoverView.removeFromSuperview()
            self.navBarImageView.removeFromSuperview()
            stripCoverView.removeFromSuperview()
            if let toView = toView {
                transitionContext.containerView().addSubview(toView)
            }
            // MARK: Testing --->
//            transitionContext.completeTransition(false)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            // <--- Testing
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
            presentViewController(vc, animated: true, completion: { [weak self] in
                println("presentViewController's completion block called.")
                println("self?.presentedViewController: \(self?.presentedViewController)")
            })
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

