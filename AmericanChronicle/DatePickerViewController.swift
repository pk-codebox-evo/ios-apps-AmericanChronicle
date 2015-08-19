//
//  DatePickerViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/15/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import FSCalendar
import SwiftMoment

@objc class DatePickerViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var slider: YearSlider!

    private let selectedDateOnInit: NSDate
    private let earliestPossibleDate: NSDate
    private let latestPossibleDate: NSDate

    @IBAction func sliderValueDidChange(sender: YearSlider) {
        setCalendarDate(year: sender.value)
    }

    var saveCallback: ((NSDate) -> ())?

    // MARK: UIViewController Init methods

    init(earliestPossibleDate: NSDate = ChroniclingAmericaArchive.earliestPossibleDate, latestPossibleDate: NSDate = ChroniclingAmericaArchive.latestPossibleDate,
        selectedDateOnInit: NSDate? = nil) {
            self.earliestPossibleDate = earliestPossibleDate
            self.latestPossibleDate = latestPossibleDate
            self.selectedDateOnInit = selectedDateOnInit ?? earliestPossibleDate

            super.init(nibName: "DatePickerViewController", bundle: nil)

            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "saveButtonTapped:")
    }

    @availability(*, unavailable) init() {
        fatalError("init not supported. Use designated initializer instead")
    }

    @availability(*, unavailable) required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported. Use designated initializer instead")
    }

    @availability(*, unavailable) override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        fatalError("init(nibName:bundle) not supported. Use designated initializer instead")
    }

    // MARK: Internal methods

    func saveButtonTapped(sender: UIBarButtonItem) {
        saveCallback?(calendarView.selectedDate)
    }

    func setCalendarDate(year: Int? = nil, month: Int? = nil) {
        if let year = year {
            println("--- will set year ---")
            println("* Original calendarView.selectedDate: \(calendarView.selectedDate)")

            let selectedMoment = moment(calendarView.selectedDate)

            println("    - year: \(selectedMoment.year)")
            println("    - month: \(selectedMoment.month)")
            println("    - day: \(selectedMoment.day)")

            let components = NSDateComponents()
            components.year = year
            components.month = selectedMoment.month
            components.day = selectedMoment.day

            let newDate = NSCalendar.currentCalendar().dateFromComponents(components)
            println("* New calendarView.selectedDate: \(newDate)")
            println("    - year: \(components.year)")
            println("    - month: \(components.month)")
            println("    - day: \(components.day)")
            calendarView.selectedDate = newDate

            println("... did set year  ...")
        }
        if let month = month {
            println("will set month")
            calendarView.selectedDate = NSCalendar.currentCalendar().dateBySettingUnit(.CalendarUnitMonth, value: month, ofDate: calendarView.selectedDate, options: NSCalendarOptions.allZeros)
            println("did set month")
        }
    }

    func updateUIToMatchCurrentDate(currentDate: NSDate) {
        if slider.state != .Highlighted {
            slider.value = moment(currentDate).year
        }
    }

    // MARK: UIViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        slider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        slider.minValue = moment(earliestPossibleDate).year
        slider.maxValue = moment(latestPossibleDate).year
        slider.value = moment(selectedDateOnInit).year

        calendarView.selectedDate = selectedDateOnInit
        println("calendarView.selectedDate: \(calendarView.selectedDate)")
        updateUIToMatchCurrentDate(calendarView.selectedDate)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var updatedText = textField.text as NSString
        updatedText = updatedText.stringByReplacingCharactersInRange(range, withString: string)
        if updatedText.length > 4 {
            return false
        }

        if updatedText.length == 0 {
            textField.backgroundColor = UIColor.grayColor()
            return true
        }

        if let year = (updatedText as String).toInt() {
            if year >= 1836 && year <= 1922 {
                setCalendarDate(year: year)
                textField.backgroundColor = UIColor.greenColor()
                // Setting calendar date will trigger its delegate's MonthDidChange method,
                // which will update the textField. If we do it here, we end up modifying 
                // the already-updated text.
                return false
            } else if updatedText.length == 4 {
                textField.backgroundColor = UIColor.redColor()
                return true
            } else {
                textField.backgroundColor = UIColor.grayColor()
                return true
            }
        } else {
            return false
        }
    }

    func calendar(calendar: FSCalendar!, shouldSelectDate date: NSDate!) -> Bool {
        return true
    }

    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {

    }

    func calendarCurrentMonthDidChange(calendar: FSCalendar) {
        updateUIToMatchCurrentDate(calendar.selectedDate)
    }

    // MARK: FSCalendarDataSource methods

    func minimumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return earliestPossibleDate
    }

    func maximumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return latestPossibleDate
    }

}
