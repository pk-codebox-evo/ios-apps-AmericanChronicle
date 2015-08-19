//
//  PageViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {

    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var bottomBarBG: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!

    var presentingViewNavBar: UIView?
    var presentingView: UIView?
    var hidesStatusBar: Bool = true

    @IBAction func shareButtonTapped(sender: AnyObject) {
        let vc = UIActivityViewController(activityItems: [], applicationActivities: nil)
        presentViewController(vc, animated: true, completion: nil)
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

    // MARK: UIViewController overrides

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
        get { return UIModalPresentationStyle.OverCurrentContext }
        set { }
    }

    @IBAction func tapRecognized(sender: AnyObject) {
        bottomBarBG.hidden = !bottomBarBG.hidden
    }

    func prepareForAppearanceAnimation() {
        view.alpha = 0
    }

    func updateViewsInsideAppearanceAnimation() {
        view.alpha = 1.0
    }

    func updateViewsInsideDisappearanceAnimation() {
        view.alpha = 0
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerContent()
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}