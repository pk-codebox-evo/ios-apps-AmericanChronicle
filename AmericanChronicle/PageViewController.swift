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
    var toastButton: UIButton = UIButton()

    var presentingViewNavBar: UIView?
    var presentingView: UIView?
    var hidesStatusBar: Bool = true
    var doneCallback: ((Void) -> ())?

    @IBAction func shareButtonTapped(sender: AnyObject) {
        let vc = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        vc.completionWithItemsHandler = { type, completed, returnedItems, activityError in
            self.toastButton.frame = CGRect(x: 20.0, y: self.bottomBarBG.frame.origin.y - 80.0, width: self.view.bounds.size.width - 40.0, height: 60)

            println("type: \(type)")
            println("completed: \(completed)")
            println("returnedItems: \(returnedItems)")
            println("activityError: \(activityError)")
            let message: String
            switch type {
            case UIActivityTypeSaveToCameraRoll:
                message = completed ? "Page saved successfully" : "Trouble saving, please try again"
            default:
                message = completed ? "Success" : "Action failed, please try again"
            }

            self.toastButton.setTitle(message, forState: .Normal)
            self.toastButton.alpha = 0
            self.toastButton.hidden = false
            UIView.animateWithDuration(0.2, animations: {
                self.toastButton.alpha = 1.0
            }, completion: { _ in
                UIView.animateWithDuration(0.2, delay: 3.0, options: UIViewAnimationOptions.allZeros, animations: {
                    self.toastButton.alpha = 0
                    }, completion: { _ in
                        self.toastButton.hidden = true
                })
            })
        }
        presentViewController(vc, animated: true, completion: nil)
    }

    @IBAction func doneButtonTapped(sender: AnyObject) {
        println("\(__FILE__) | \(__FUNCTION__) | line \(__LINE__)")
        doneCallback?()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toastButton.addTarget(self, action: "toastButtonTapped:", forControlEvents: .TouchUpInside)
        toastButton.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        toastButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        toastButton.layer.shadowColor = UIColor.blackColor().CGColor
        toastButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        toastButton.layer.shadowRadius = 1.0
        toastButton.layer.shadowOpacity = 1.0

        view.addSubview(toastButton)
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