//
//  Reporter.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 3/19/16.
//  Copyright © 2016 ryanipete. All rights reserved.
//

import Fabric
import Crashlytics

struct Reporter {
    static let sharedInstance = Reporter()
    func applicationDidFinishLaunching() {
        Fabric.with([Crashlytics.self])
    }

    func applicationDidBecomeActive() {
        updateReportedLocale()
    }

    func logMessage(formattedString: String, arguments: [CVarArgType] = []) {
        CLSNSLogv(formattedString, getVaList(arguments))
    }

    private func updateReportedLocale() {
        let locale = NSLocale.currentLocale().localeIdentifier
        Crashlytics.sharedInstance().setObjectValue(locale, forKey: "locale")
    }
}