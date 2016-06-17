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
