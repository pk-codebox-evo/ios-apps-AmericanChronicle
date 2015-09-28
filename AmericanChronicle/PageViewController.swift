//
//  PageViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

public protocol PageView: class {
    var doneCallback: ((Void) -> ())? { get set }
    var shareCallback: ((Void) -> ())? { get set }
    var pdfPage: CGPDFPageRef? { get set }

    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showErrorWithTitle(title: String?, message: String?)
}

extension CGPDFPageRef {
    var mediaBoxRect: CGRect {
        return CGPDFPageGetBoxRect(self, .MediaBox)
    }
}

class PageViewController: UIViewController, PageView, UIScrollViewDelegate {

    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var bottomBarBG: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    lazy var pageView: PDFPageView = PDFPageView()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var toastButton = UIButton()
    var presentingViewNavBar: UIView?
    var presentingView: UIView?
    var hidesStatusBar: Bool = true
    var doneCallback: ((Void) -> ())?
    var shareCallback: ((Void) -> ())?
    var pdfPage: CGPDFPageRef? {
        get {
            return pageView.pdfPage
        }
        set {
            p("[RP] ENTERING pdfPage's setter")
            pageView.pdfPage = newValue
            pageView.frame = pageView.pdfPage?.mediaBoxRect ?? CGRectZero
            view.setNeedsLayout()
            p("[RP] EXITING pdfPage's setter")
        }
    }

    let loggingEnabled = true
    func p(string: String) {
        if loggingEnabled {
            print(string)
        }
    }

    @IBAction func shareButtonTapped(sender: AnyObject) {
        shareCallback?()
    }

    @IBAction func doneButtonTapped(sender: AnyObject) {
        doneCallback?()
    }

    override func viewDidLoad() {
        p("[RP] ENTERING viewDidLoad()")
        super.viewDidLoad()
        scrollView.addSubview(pageView)

        doneButton.setBackgroundImage(nil, forState: .Normal)
        doneButton.setTitleColor(UIColor.lightTextColor(), forState: .Normal)
        doneButton.setTitle(nil, forState: .Normal)
        doneButton.tintColor = UIColor.whiteColor()
        doneButton.setImage(UIImage(named: "UIAccessoryButtonX")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)

        shareButton.setBackgroundImage(nil, forState: .Normal)
        shareButton.setTitleColor(UIColor.lightTextColor(), forState: .Normal)
        shareButton.setTitle(nil, forState: .Normal)
        shareButton.tintColor = UIColor.whiteColor()
        shareButton.setImage(UIImage(named: "UIButtonBarAction")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)

        toastButton.addTarget(self, action: "toastButtonTapped:", forControlEvents: .TouchUpInside)
        toastButton.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        toastButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        toastButton.layer.shadowColor = UIColor.blackColor().CGColor
        toastButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        toastButton.layer.shadowRadius = 1.0
        toastButton.layer.shadowOpacity = 1.0
        view.addSubview(toastButton)

        showLoadingIndicator()

        p("[RP] EXITING viewDidLoad()")
    }

    func showLoadingIndicator() {
        if isViewLoaded() {
            activityIndicator.startAnimating()
        }
    }

    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }

    func showErrorWithTitle(title: String?, message: String?) {
        
    }

    // MARK: UIViewController overrides

    override func viewWillAppear(animated: Bool) {
        p("[RP] ENTERING viewWillAppear(:)")
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
        p("[RP] EXITING viewWillAppear(:)")
    }

    func matchPageViewSizeToPDFSize() {
        let pdfSize = CGPDFPageGetBoxRect(pageView.pdfPage, .MediaBox).size
        print("[RP]  * pdfSize: \(pdfSize)")
        print("[RP]  * view.frame: \(view.frame)")
        print("[RP]  * scrollView.frame: \(scrollView.frame)")
        print("[RP]  * UIScreen.mainScreen().bounds: \(UIScreen.mainScreen().bounds)")
        let fractionOfWidth = Float(scrollView.bounds.size.width/pdfSize.width)
        print("[RP]  * fractionOfWidth: \(fractionOfWidth)")
        let fractionOfHeight = Float(scrollView.bounds.size.height/pdfSize.height)
        print("[RP]  * fractionOfHeight: \(fractionOfHeight)")
        let smallerFraction = fminf(fractionOfWidth, fractionOfHeight)
        print("[RP]  * smallerFraction: \(smallerFraction)")
        var pageViewFrame = scrollView.bounds
        pageViewFrame.size.width = scrollView.bounds.size.width/CGFloat(smallerFraction)
        pageViewFrame.size.height = scrollView.bounds.size.height/CGFloat(smallerFraction)
        print("[RP]  * pageViewFrame: \(pageViewFrame)")
        pageView.frame = pageViewFrame
        pageView.layer.setNeedsDisplay()
        scrollView.contentSize = pageView.frame.size
        scrollView.minimumZoomScale = CGFloat(smallerFraction)
        scrollView.zoomScale = CGFloat(smallerFraction)

        print("[RP]  * scrollView.minimumZoomScale: \(scrollView.minimumZoomScale)")
        print("[RP]  * scrollView.zoomScale: \(scrollView.zoomScale)")

        view.setNeedsDisplay()
    }

    override func viewDidLayoutSubviews() {
        p("[RP] ENTERING viewDidLayoutSubviews()")

        let scrollViewWidthOverPageWidth: CGFloat
        if let pageWidth = pageView.pdfPage?.mediaBoxRect.size.width where pageWidth > 0 {
            scrollViewWidthOverPageWidth = scrollView.bounds.size.width/pageWidth
        } else {
            scrollViewWidthOverPageWidth = 1.0
        }
        scrollView.minimumZoomScale = scrollViewWidthOverPageWidth
        scrollView.zoomScale = scrollView.minimumZoomScale

        p("[RP] EXITING viewDidLayoutSubviews()")
    }

    override func viewDidAppear(animated: Bool) {
        p("[RP] ENTERING viewDidAppear(:)")
        super.viewDidAppear(animated)
        p("[RP] EXITING viewDidAppear(:)")
    }

    override var modalPresentationStyle: UIModalPresentationStyle {
        get { return .OverCurrentContext }
        set { }
    }

    @IBAction func tapRecognized(sender: AnyObject) {
        bottomBarBG.hidden = !bottomBarBG.hidden
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return pageView
    }
}