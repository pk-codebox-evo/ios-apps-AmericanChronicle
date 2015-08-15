//
//  CalendarViewDataSource.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/15/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewDataSource: NSObject, FSCalendarDataSource {



    // MARK: FSCalendarDataSource methods

    func minimumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return ChroniclingAmericaArchive.earliestPossibleDate
    }

    func maximumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return ChroniclingAmericaArchive.latestPossibleDate
    }
}
