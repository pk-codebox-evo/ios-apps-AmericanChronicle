//
//  ChroniclingAmericaWebsiteViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 1/21/16.
//  Copyright © 2016 ryanipete. All rights reserved.
//

import WebKit

class ChroniclingAmericaWebsiteViewController: UIViewController {

    var userDidDismiss: ((Void) -> Void)?

    private let webView = WKWebView()

    // MARK: UIViewController Init methods

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported. Use designated initializer instead")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .Plain, target: self, action: "dismissButtonTapped:")
        navigationItem.leftBarButtonItem?.setTitlePositionAdjustment(Measurements.leftBarButtonItemTitleAdjustment, forBarMetrics: .Default)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()

        view.addSubview(webView)
        webView.snp_makeConstraints { make in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }

        let request = NSURLRequest(URL: NSURL(string: "http://chroniclingamerica.loc.gov/")!)
        webView.loadRequest(request)
    }

    func dismissButtonTapped(sender: UIBarButtonItem) {
        userDidDismiss?()
    }

}
