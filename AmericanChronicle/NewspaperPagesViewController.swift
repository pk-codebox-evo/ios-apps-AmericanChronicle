//
//  DetailViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class NewspaperPagesViewController: UIViewController, UICollectionViewDelegate, NewspaperPagesPreviewActionHandler, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var previewCollectionView: UICollectionView!
    @IBOutlet weak var stripCollectionView: UICollectionView!
    @IBOutlet var previewDelegate: NewspaperPagesPreviewDelegate!
    @IBOutlet var dataSource: NewspaperPagesDataSource!
    var issue: NewspaperIssue? {
        didSet {
            if !isViewLoaded() {
                return
            }
            println("\(__FILE__) | \(__FUNCTION__) | line \(__LINE__)")
            previewDelegate.issue = issue
        }
    }

    var focusTransition: PageFocusTransition?

    @IBAction func pinchRecognized(sender: UIPinchGestureRecognizer) {
        if let transition = focusTransition {
            transition.progress = sender.scale - 1.0
        } else {
            focusTransition = PageFocusTransition()
        let sb = UIStoryboard(name: "Page", bundle: nil)
            if let vc = sb.instantiateInitialViewController() as? PageViewController {
                vc.imageName = issue?.imageName
                vc.transitioningDelegate = self
                vc.modalPresentationStyle = .Custom
                vc.doneCallback = { [weak self] in
                    self?.dismissViewControllerAnimated(true, completion: nil)
                }
                presentViewController(vc, animated: true, completion: nil)
            }
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

    // MARK: UIViewControllerTransitioningDelegate methods

//    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return PageFocusTransition()
//    }
//    class PageFocusTransition: NSObject, UIViewControllerAnimatedTransitioning {
//        let duration = 1.0
//        func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
//            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
//            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
//            if let pagesViewController = fromVC as? NewspaperPagesViewController,
//                   pageViewController = toVC as? PageViewController {
//
//                var presentingVC: UIViewController? = pagesViewController
//                while !(presentingVC?.definesPresentationContext ?? false) {
//                    presentingVC = presentingVC?.parentViewController
//                }
//
//                println("presentingVC: \(presentingVC)")
//
//                let fullScreenImage = imageOfWindow()
//
//                fullScreenImageView.image = fullScreenImage
//                fullScreenImageView.frame = CGRect(x: 0, y: 0, width: fullScreenImage.size.width, height: fullScreenImage.size.height)
//
//                navBarImageView.image = fullScreenImage
//                navBarImageView.frame = CGRect(x: 0, y: 0, width: fullScreenImage.size.width, height: 64.0)
//
//                pageViewController.prepareForAppearanceAnimation()
//
//                presentingVC?.view.addSubview(fullScreenImageView)
//
//                presentingVC?.view.addSubview(navBarCoverView)
//
//                presentingVC?.view.addSubview(pageViewController.view)
//
//                presentingVC?.view.addSubview(navBarImageView)
//
//                pageViewController.presentingView = fullScreenImageView
//                pageViewController.presentingViewNavBar = navBarImageView
//
//                UIView.animateWithDuration(2.0, animations: {
//                    pageViewController.updateViewsInsideAppearanceAnimation()
//                    self.navBarImageView.frame = CGRectOffset(self.navBarImageView.frame, 0, -64.0)
//                    }, completion: { _ in
//                        self.navBarImageView.removeFromSuperview()
//                        self.navBarCoverView.removeFromSuperview()
//                        self.fullScreenImageView.removeFromSuperview()
//                        pagesViewController.presentViewController(pageViewController, animated: false, completion: nil)
//                })
//            }
//        }
//
//        func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
//            return duration
//        }
//    }


    //func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    //}

    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return focusTransition
    }

    class PageFocusTransition: NSObject, UIViewControllerInteractiveTransitioning {

        var context: UIViewControllerContextTransitioning?
        var progress: CGFloat = 0 {
            didSet {
                println("progress: \(progress)")
                // update progress
//                pageViewController.updateViewsInsideAppearanceAnimation()
                let offset = -64.0 * progress
                var navBarFrame = self.navBarImageView.frame
                navBarFrame.origin.y = offset
                self.navBarImageView.frame = navBarFrame
                context?.updateInteractiveTransition(progress)
                if progress >= 1.0 {
                    println("\(__FILE__) | \(__FUNCTION__) | line \(__LINE__)")
                    context?.completeTransition(true)
                }
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
            return UIImageView()
            }()

        var navBarImageView: UIImageView = {
            let navBarImageView = UIImageView()
            navBarImageView.clipsToBounds = true
            navBarImageView.contentMode = .Top
            return navBarImageView
            }()

        func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
            context = transitionContext
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)

            if let pagesViewController = fromVC as? NewspaperPagesViewController,
                   pageViewController = toVC as? PageViewController {

                    var presentingVC: UIViewController? = pagesViewController

                    while !(presentingVC?.definesPresentationContext ?? false) {
                        presentingVC = presentingVC?.parentViewController
                    }

                    let fullScreenImage = imageOfWindow()

//                    fullScreenImageView.image = fullScreenImage
                    fullScreenImageView.frame = CGRect(x: 0, y: 0, width: fullScreenImage.size.width, height: fullScreenImage.size.height)
                    fullScreenImageView.backgroundColor = UIColor.greenColor()

                    navBarImageView.image = fullScreenImage
                    navBarImageView.frame = CGRect(x: 0, y: 0, width: fullScreenImage.size.width, height: 64.0)

//                    pageViewController.prepareForAppearanceAnimation()

                    presentingVC?.view.addSubview(fullScreenImageView)
//
//                    presentingVC?.view.addSubview(navBarCoverView)
//
//                    presentingVC?.view.addSubview(pageViewController.view)
//
//                    presentingVC?.view.addSubview(navBarImageView)
//
//                    pageViewController.presentingView = fullScreenImageView
//                    pageViewController.presentingViewNavBar = navBarImageView

//                    UIView.animateWithDuration(2.0, animations: {
//                        pageViewController.updateViewsInsideAppearanceAnimation()
//                        self.navBarImageView.frame = CGRectOffset(self.navBarImageView.frame, 0, -64.0)
//                        }, completion: { _ in
//                            self.navBarImageView.removeFromSuperview()
//                            self.navBarCoverView.removeFromSuperview()
//                            self.fullScreenImageView.removeFromSuperview()
//                            pagesViewController.presentViewController(pageViewController, animated: false, completion: nil)
//                    })
            }

        }

//        func completionSpeed() -> CGFloat {
//
//        }
//        func completionCurve() -> UIViewAnimationCurve {
//
//        }
    }

    //func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    //}

    //func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
    //}

}

