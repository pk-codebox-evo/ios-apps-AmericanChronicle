//
//  NSDate+AMC.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 12/27/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import Foundation

extension NSDate {
    var year: Int {
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        return calendar.component(NSCalendarUnit.Year, fromDate: self)
    }

    var month: Int {
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        return calendar.component(NSCalendarUnit.Month, fromDate: self)
    }
}