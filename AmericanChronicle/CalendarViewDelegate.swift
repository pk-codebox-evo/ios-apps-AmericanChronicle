//
//  CalendarViewDelegate.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/15/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewDelegate: NSObject, FSCalendarDelegate {
    // MARK: FSCalendarDelegate methods

    func calendar(calendar: FSCalendar, shouldSelectDate: NSDate) -> Bool {
        return false
    }

    func calendar(calendar: FSCalendar, didSelectDate: NSDate) {

    }

    func calendarCurrentMonthDidChange(calendar: FSCalendar) {
//        updateLabelsWithCurrentCalendarViewDate()
    }
}
