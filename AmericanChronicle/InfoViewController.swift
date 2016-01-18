//
//  InfoViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 1/18/16.
//  Copyright © 2016 ryanipete. All rights reserved.
//

import UIKit
import WebKit

class InfoViewController: UIViewController {

    var userDidDismiss: ((Void) -> Void)?

    private let webView = WKWebView()


    // MARK: UIViewController Init methods

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported. Use designated initializer instead")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .Plain, target: self, action: "dismissButtonTapped:")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
