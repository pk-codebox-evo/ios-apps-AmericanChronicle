struct DayMonthYear: CustomStringConvertible {

    private static let timeZone = NSTimeZone(forSecondsFromGMT: 0)
    private static let calendar: NSCalendar = {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        calendar.timeZone = DayMonthYear.timeZone
        return calendar
    }()

    private static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.calendar = DayMonthYear.calendar
        // Reminder - Setting the formatter's calendar doesn't
        //  change the formatter's timeZone to match.
        formatter.timeZone = DayMonthYear.timeZone
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()

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

    static func symbolForMonth(month: Int) -> String? {
        let zeroBasedMonth = month - 1
        let monthStrings = allMonthSymbols()
        guard zeroBasedMonth < monthStrings.count else { return nil }
        return monthStrings[zeroBasedMonth]
    }

    static func allMonthSymbols() -> [String] {
        return ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    }

    init(day: Int, month: Int, year: Int) {

        self.month = month
        self.year = year

        // Guard against invalid day
        let components = NSDateComponents()
        components.calendar = DayMonthYear.calendar
        // Reminder - Setting the components calendar doesn't
        //  change the components timeZone to match.
        components.timeZone = DayMonthYear.timeZone
        components.month = month
        components.year = year
        components.day = 1
        if let date = components.date {
            let daysInMonth = components.calendar?.rangeOfUnit(.Day,
                                                               inUnit: .Month,
                                                               forDate: date).length ?? 1
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
        // Reminder - Setting the components calendar doesn't
        //  change the components timeZone to match.
        components.timeZone = DayMonthYear.timeZone
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
func == (lhs: DayMonthYear, rhs: DayMonthYear) -> Bool {
    return (lhs.day == rhs.day)
        && (lhs.month == rhs.month)
        && (lhs.year == rhs.year)
}
