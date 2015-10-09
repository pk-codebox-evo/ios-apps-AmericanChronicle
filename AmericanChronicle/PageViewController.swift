//
//  PageViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

// -
// MARK: PageViewController Class

class PageViewController: UIViewController, PageView, UIScrollViewDelegate {

    // MARK: Properties

    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var bottomBarBG: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!

    lazy var pageView: PDFPageView = PDFPageView()
    var toastButton = UIButton()
    var presentingViewNavBar: UIView?
    var presentingView: UIView?
    var hidesStatusBar: Bool = true

    // MARK: Internal methods

    @IBAction func shareButtonTapped(sender: AnyObject) {
        shareCallback?()
    }

    @IBAction func doneButtonTapped(sender: AnyObject) {
        doneCallback?()
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        cancelCallback?()
    }

    @IBAction func tapRecognized(sender: AnyObject) {
        bottomBarBG.hidden = !bottomBarBG.hidden
    }

    // MARK: PageView protocol

    var doneCallback: ((Void) -> ())?
    var shareCallback: ((Void) -> ())?
    var cancelCallback: ((Void) -> ())?
    var pdfPage: CGPDFPageRef? {
        get {
            return pageView.pdfPage
        }
        set {
            pageView.pdfPage = newValue
            pageView.frame = pageView.pdfPage?.mediaBoxRect ?? CGRectZero
            view.setNeedsLayout()
        }
    }

    func showLoadingIndicator() {
        if isViewLoaded() {
            loadingView.alpha = 1.0
            activityIndicator.startAnimating()
        }
    }

    func hideLoadingIndicator() {
        loadingView.alpha = 0
        activityIndicator.stopAnimating()
    }

    func setDownloadProgress(progress: Float) {
        progressView.progress = progress
    }

    func showErrorWithTitle(title: String?, message: String?) {
        errorTitleLabel.text = title
        errorMessageLabel.text = message
        errorView.hidden = false
    }

    func hideError() {
        errorView.hidden = true
    }

    @IBAction func errorOKButtonTapped(sender: AnyObject) {
        doneCallback?()
    }

    // MARK: UIScrollViewDelegate protocol

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return pageView
    }

    // MARK: UIViewController overrides

    override var modalPresentationStyle: UIModalPresentationStyle {
        get { return .OverCurrentContext }
        set { }
    }

    override func viewDidLoad() {
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

        hideError()

        showLoadingIndicator()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
    }

    override func viewDidLayoutSubviews() {
        let scrollViewWidthOverPageWidth: CGFloat
        if let pageWidth = pageView.pdfPage?.mediaBoxRect.size.width where pageWidth > 0 {
            scrollViewWidthOverPageWidth = scrollView.bounds.size.width/pageWidth
        } else {
            scrollViewWidthOverPageWidth = 1.0
        }
        scrollView.minimumZoomScale = scrollViewWidthOverPageWidth
        scrollView.zoomScale = scrollView.minimumZoomScale
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}