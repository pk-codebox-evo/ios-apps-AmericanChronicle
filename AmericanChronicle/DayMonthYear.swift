//
//  DayMonthYear.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 3/6/16.
//  Copyright © 2016 ryanipete. All rights reserved.
//

import Foundation

struct DayMonthYear: CustomStringConvertible {
    private let components = NSDateComponents()

    let day: Int // 1-based
    let month: Int // 1-based
    let year: Int
    var monthSymbol: String? {
        return DayMonthYear.symbolForMonth(month)
    }

    var userVisibleString: String {
        guard let date = dateComponents().date else { return "" }
        return DayMonthYear.dateFormatter.stringFromDate(date)
    }

    private static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()

    /// month should be 1-based
    static func symbolForMonth(month: Int) -> String? {
        let zeroBasedMonth = month - 1
        let monthStrings = allMonthSymbols()
        guard zeroBasedMonth < monthStrings.count else { return nil }
        return monthStrings[zeroBasedMonth]
    }

    static let formatter = NSDateFormatter()

    private static let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!

    static func allMonthSymbols() -> [String] {
        return ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    }

    init(day: Int, month: Int, year: Int) {

        self.month = month
        self.year = year

        let components = NSDateComponents()
        components.calendar = DayMonthYear.calendar
        components.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        components.month = month
        components.year = year
        components.day = 1
        if let date = components.date {
            let daysInMonth = components.calendar?.rangeOfUnit(.Day, inUnit: .Month, forDate: date).length ?? 1
            if day < 1 {
                self.day = 1
            } else if day > daysInMonth {
                self.day = daysInMonth
            } else {
                self.day = day
            }
        } else {
            self.day = 1
        }
    }

    func copyWithDay(dayToUse: Int) -> DayMonthYear {
        return DayMonthYear(day: dayToUse, month: month, year: year)
    }

    func copyWithMonth(monthToUse: Int) -> DayMonthYear {
        return DayMonthYear(day: day, month: monthToUse, year: year)
    }

    func copyWithYear(yearToUse: Int) -> DayMonthYear {
        return DayMonthYear(day: day, month: month, year: yearToUse)
    }

    func rangeOfDaysInMonth() -> NSRange? {
        let components = dateComponents()
        guard let date = components.date else { return nil }
        return DayMonthYear.calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: date)
    }

    var weekday: Int? {
        let components = dateComponents()
        guard let date = components.date else { return nil }
        return DayMonthYear.calendar.component(.Weekday, fromDate: date)
    }

    var weekOfMonth: Int? {
        let components = dateComponents()
        guard let date = components.date else { return nil }
        return DayMonthYear.calendar.component(.WeekOfMonth, fromDate: date)
    }

    private func dateComponents() -> NSDateComponents {
        let components = NSDateComponents()
        components.calendar = DayMonthYear.calendar
        components.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        components.day = day
        components.month = month
        components.year = year
        return components
    }

    var description: String {
        return userVisibleString
    }
}

extension DayMonthYear: Equatable {}
func ==(lhs: DayMonthYear, rhs: DayMonthYear) -> Bool {
    return (lhs.day == rhs.day)
        && (lhs.month == rhs.month)
        && (lhs.year == rhs.year)
}
