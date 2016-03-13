//
//  AppDelegate.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import ZendeskSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let rootWireframe = RootWireframe()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        ZDKConfig.instance().initializeWithAppId("f5f58e30fdcc4f60ff675d3021c6511429ca7c318e7e7eb6",
            zendeskUrl: "https://ryanpeterson.zendesk.com",
            clientId: "mobile_sdk_client_6653f492fd785f23ee1a",
            onSuccess: {
            print("[RP] \(_stdlib_getDemangledTypeName(self)) | \(__FUNCTION__) | line \(__LINE__)")
        }, onError: { error in
            print("[RP] \(_stdlib_getDemangledTypeName(self)) | \(__FUNCTION__) | line \(__LINE__)")
        })
        let identity = ZDKAnonymousIdentity()
        ZDKConfig.instance().userIdentity = identity

        Fabric.with([Crashlytics.self])
        KeyboardService.sharedInstance.applicationDidFinishLaunching()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = rootWireframe.rootViewController()
        window?.makeKeyAndVisible()
        Appearance.apply()
        return true
    }
}

