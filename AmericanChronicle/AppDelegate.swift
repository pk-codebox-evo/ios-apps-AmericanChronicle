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
        Reporter.sharedInstance.applicationDidFinishLaunching()
        KeyboardService.sharedInstance.applicationDidFinishLaunching()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = rootWireframe.rootViewController()
        window?.makeKeyAndVisible()
        Appearance.apply()
        return true
    }

    func applicationDidBecomeActive(application: UIApplication) {
        Reporter.sharedInstance.applicationDidBecomeActive()
    }
}

