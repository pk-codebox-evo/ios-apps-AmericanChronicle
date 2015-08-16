//
//  ChroniclingAmericaArchive.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/15/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

struct ChroniclingAmericaArchive {
    static let earliestPossibleDate: NSDate = {
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.year = 1836
        return calendar.dateFromComponents(components)!
    }()

    static let latestPossibleDate: NSDate = {
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.year = 1922
        components.month = 12
        components.day = 31
        return calendar.dateFromComponents(components)!
    }()
}
