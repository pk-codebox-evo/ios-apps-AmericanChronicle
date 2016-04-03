//
//  InfoViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 1/18/16.
//  Copyright © 2016 ryanipete. All rights reserved.
//

import ZendeskSDK

class InfoViewController: UIViewController {

    var userDidDismiss: ((Void) -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.darkGray
        label.textAlignment = .Center
        label.font = Font.largeBodyBold
        label.numberOfLines = 0
        label.text = "American Chronicle gets its data from the Chronicling America website."
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.darkGray
        label.textAlignment = .Center
        label.numberOfLines = 0
        label.font = Font.mediumBody
        label.text = "American Chronicle gets its data from the 'Chronicling America' website.\n\n'Chronicling America' is a project funded by the National Endowment for the Humanities and maintained by the Library of Congress."
        return label
    }()

    private let websiteButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = Font.mediumBody
        btn.setTitleColor(Colors.lightBlueBright, forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        btn.setBackgroundImage(UIImage.imageWithFillColor(UIColor.whiteColor(), borderColor: Colors.lightBlueBright), forState: .Normal)
        btn.setBackgroundImage(UIImage.imageWithFillColor(Colors.lightBlueBright, borderColor: Colors.lightBlueBright), forState: .Highlighted)
        btn.setTitle("Visit chroniclingamerica.gov.loc", forState: .Normal)

        return btn
    }()

    private let separator = UIImageView(image: UIImage.imageWithFillColor(Colors.lightBlueBright, borderColor: Colors.lightBlueBright))

    private let suggestionsLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.darkGray
        label.textAlignment = .Center
        label.numberOfLines = 0
        label.font = Font.mediumBody
        label.text = "Do you have a question, suggestion or complaint about the app?"
        return label
    }()

    private let suggestionsButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = Font.mediumBody
        btn.setTitleColor(Colors.lightBlueBright, forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        btn.setBackgroundImage(UIImage.imageWithFillColor(UIColor.whiteColor(), borderColor: Colors.lightBlueBright), forState: .Normal)
        btn.setBackgroundImage(UIImage.imageWithFillColor(Colors.lightBlueBright, borderColor: Colors.lightBlueBright), forState: .Highlighted)
        btn.setTitle("Send us a message", forState: .Normal)

        return btn
    }()

    // MARK: UIViewController Init methods

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported. Use designated initializer instead")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        navigationItem.title = "About this app"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .Plain, target: self, action: #selector(InfoViewController.dismissButtonTapped(_:)))
        navigationItem.leftBarButtonItem?.setTitlePositionAdjustment(Measurements.leftBarButtonItemTitleAdjustment, forBarMetrics: .Default)

        ZDKConfig.instance().initializeWithAppId("f5f58e30fdcc4f60ff675d3021c6511429ca7c318e7e7eb6",
            zendeskUrl: "https://ryanpeterson.zendesk.com",
            clientId: "mobile_sdk_client_6653f492fd785f23ee1a",
            onSuccess: {
                print("[RP] Zendesk request sent successfully")
            }, onError: { error in
                print("[RP] Zendesk request failed")
        })
        let identity = ZDKAnonymousIdentity()
        ZDKConfig.instance().userIdentity = identity
    }

    let versionNumber: String = {
        let version = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
        return version ?? "not found"
    }()

    var buildNumber: String = {
        let build = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as? String
        return build ?? "not found"
    }()

    func suggestionsButtonTapped(sender: UIButton) {
        ZDKRequests.configure { account, config in
            config.tags = [self.versionNumber]
            config.additionalRequestInfo = "Build: \(self.buildNumber)"
            config.subject = "American Chronicle"
        }
        ZDKRequests.showRequestCreationWithNavController(self.navigationController)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.lightBackground

        view.addSubview(bodyLabel)
        bodyLabel.snp_makeConstraints { make in
            make.top.equalTo(Measurements.verticalMargin)
            make.leading.equalTo(Measurements.horizontalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)
        }

        websiteButton.addTarget(self, action: #selector(InfoViewController.websiteButtonTapped(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(websiteButton)
        websiteButton.snp_makeConstraints { make in
            make.top.equalTo(bodyLabel.snp_bottom).offset(Measurements.verticalSiblingSpacing * 2)
            make.leading.equalTo(Measurements.horizontalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)
            make.height.equalTo(Measurements.buttonHeight)
        }

        view.addSubview(separator)
        separator.snp_makeConstraints { make in
            make.top.equalTo(websiteButton.snp_bottom).offset(Measurements.verticalMargin * 2)
            make.leading.equalTo(Measurements.horizontalMargin * 2)
            make.trailing.equalTo(-Measurements.horizontalMargin * 2)
            make.height.equalTo(1.0/UIScreen.mainScreen().nativeScale)
        }

        view.addSubview(suggestionsLabel)
        suggestionsLabel.snp_makeConstraints { make in
            make.top.equalTo(separator.snp_bottom).offset(Measurements.verticalMargin)
            make.leading.equalTo(Measurements.horizontalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)
        }

        suggestionsButton.addTarget(self, action: #selector(InfoViewController.suggestionsButtonTapped(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(suggestionsButton)
        suggestionsButton.snp_makeConstraints { make in
            make.top.equalTo(suggestionsLabel.snp_bottom).offset(Measurements.verticalSiblingSpacing * 2)
            make.leading.equalTo(Measurements.horizontalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)
            make.height.equalTo(Measurements.buttonHeight)
        }
    }

    func dismissButtonTapped(sender: UIBarButtonItem) {
        userDidDismiss?()
    }

    func websiteButtonTapped(sender: UIBarButtonItem) {
        let vc = ChroniclingAmericaWebsiteViewController()
        vc.userDidDismiss = {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let nvc = UINavigationController(rootViewController: vc)
        presentViewController(nvc, animated: true, completion: nil)
    }
}
