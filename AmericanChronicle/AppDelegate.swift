//
//  AppDelegate.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let rootWireframe = RootWireframe()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        KeyboardObserver.sharedInstance.applicationDidFinishLaunching()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = rootWireframe.rootViewController()
        window?.makeKeyAndVisible()
        Appearance.apply()
        return true
    }
}

