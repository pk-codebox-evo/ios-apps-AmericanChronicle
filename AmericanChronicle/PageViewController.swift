//
//  PageViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var bottomBarBG: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func doneButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    var presentingViewNavBar: UIView?
    var presentingView: UIView?
    var hidesStatusBar: Bool = true

    @IBAction func shareButtonTapped(sender: AnyObject) {
    }

    func centerContent() {
        var top: CGFloat = 0
        var left: CGFloat = 0
        if scrollView.contentSize.width < scrollView.bounds.size.width {
            left = (scrollView.bounds.size.width-scrollView.contentSize.width) * 0.5
        }

        if scrollView.contentSize.height < scrollView.bounds.size.height {
            top = (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5
        }

        scrollView.contentInset = UIEdgeInsetsMake(top, left, top, left);
    }

    override func viewDidLayoutSubviews() {

        if let imageWidth = imageView.image?.size.width where imageWidth > 0 {
            scrollView.minimumZoomScale = scrollView.frame.size.width / imageWidth

        } else {
            scrollView.minimumZoomScale = 1.0
        }
        scrollView.zoomScale = scrollView.minimumZoomScale
        centerContent()
    }

    override var modalPresentationStyle: UIModalPresentationStyle {
        get {
            return UIModalPresentationStyle.OverCurrentContext
        }
        set {

        }
    }

    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBAction func tapRecognized(sender: AnyObject) {
        bottomBarBG.hidden = !bottomBarBG.hidden
    }

    func prepareForAppearanceAnimation() {
        view.alpha = 0
    }

    func updateViewsInsideAppearanceAnimation() {
        view.alpha = 1.0
    }

    func prepareForDisappearanceAnimation() {

    }

    func updateViewsInsideDisappearanceAnimation() {
        view.alpha = 0
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

//    optional func scrollViewDidScroll(scrollView: UIScrollView) // any offset changes

    func scrollViewDidZoom(scrollView: UIScrollView) { // any zoom scale changes
//        println("scrollView.bounds.size.width: \(scrollView.bounds.size.width)")
//        println("scrollView.contentSize.width: \(scrollView.contentSize.width)")
//
//        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) / 2.0, 0)
//        println("offsetX: \(offsetX)")
//        let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) / 2.0, 0)
//        println("offsetY: \(offsetY)")
//        let x = (scrollView.contentSize.width / 2.0) + offsetX
//        println("x: \(x)")
//        let y = (scrollView.contentSize.height / 2.0) + offsetY
//        println("y: \(y)")
//        imageView.center = CGPoint(x: x, y: y)
        centerContent()
    }
//

//    // called on start of dragging (may require some time and or distance to move)
//    optional func scrollViewWillBeginDragging(scrollView: UIScrollView)

//    // called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
//    @availability(iOS, introduced=5.0)
//    optional func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)

//    // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
//    optional func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool)

//
//    optional func scrollViewWillBeginDecelerating(scrollView: UIScrollView) // called on finger up as we are moving

//    optional func scrollViewDidEndDecelerating(scrollView: UIScrollView) // called when scroll view grinds to a halt
//
//    optional func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
//
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

//    @availability(iOS, introduced=3.2)
//    optional func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView!) // called before the scroll view begins zooming its content

//    optional func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) // scale between minimum and maximum. called after any 'bounce' animations
//
//    optional func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool // return a yes if you want to scroll to the top. if not defined, assumes YES
//    optional func scrollViewDidScrollToTop(scrollView: UIScrollView) // called when scrolling animation finished. may be called immediately if already at top
}