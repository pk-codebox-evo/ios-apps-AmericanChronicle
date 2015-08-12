//
//  SearchFiltersViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/11/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class SearchFiltersViewController: UIViewController, CVCalendarViewDelegate, MenuViewDelegate {

    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        calendarView.commitCalendarViewUpdate()
        calendarMenuView.commitMenuViewUpdate()
        yearTextField.text = "\(calendarView.presentedDate.year)"
        monthTextField.text = "\(calendarView.presentedDate.month)"

    }

//    optional func textFieldShouldBeginEditing(textField: UITextField) -> Bool // return NO to disallow editing.
//    optional func textFieldDidBeginEditing(textField: UITextField) // became first responder
//    optional func textFieldShouldEndEditing(textField: UITextField) -> Bool // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
//    optional func textFieldDidEndEditing(textField: UITextField) // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
//
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        var updatedText = textField.text as NSString
        updatedText = updatedText.stringByReplacingCharactersInRange(range, withString: string)
        if textField == yearTextField {
            if let year = (updatedText as String).toInt() where year >= 1836 && year <= 1922 {
                calendarView.toggleViewWithDate(Date(day: calendarView.presentedDate.day, month: calendarView.presentedDate.month, week: calendarView.presentedDate.week, year: year).convertedDate()!)
            }
        } else if textField == monthTextField {
            if let month = (updatedText as String).toInt() where month >= 1 && month <= 12 {
                calendarView.toggleViewWithDate(Date(day: calendarView.presentedDate.day, month: month, week: calendarView.presentedDate.week, year: calendarView.presentedDate.year).convertedDate()!)
            }
        }


        return true
    }
//
//    optional func textFieldShouldClear(textField: UITextField) -> Bool // called when clear button pressed. return NO to ignore (no notifications)
//    optional func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.

    func presentationMode() -> CalendarMode {
        return CalendarMode.MonthView
    }
    func firstWeekday() -> Weekday {
        return Weekday.Sunday
    }
//
//    optional func shouldShowWeekdaysOut() -> Bool
    func didSelectDayView(dayView: DayView) {
        println("dayView: \(dayView)")
        println("calendarView.presentedDate: \(calendarView.presentedDate.globalDescription)")
        yearTextField.text = "\(calendarView.presentedDate.year)"
        monthTextField.text = "\(calendarView.presentedDate.month)"
    }
//    optional func presentedDateUpdated(date: Date)
//    optional func topMarker(shouldDisplayOnDayView dayView: DayView) -> Bool
//    optional func dotMarker(shouldMoveOnHighlightingOnDayView dayView: DayView) -> Bool
//    optional func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool
//    optional func dotMarker(colorOnDayView dayView: DayView) -> [UIColor]
//    optional func dotMarker(moveOffsetOnDayView dayView: DayView) -> CGFloat
//
//    optional func preliminaryView(viewOnDayView dayView: DayView) -> UIView
//    optional func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool
//
//    optional func supplementaryView(viewOnDayView dayView: DayView) -> UIView
//    optional func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool


//    func firstWeekday() -> Weekday {
//        return .Sunday
//    }
//    optional func dayOfWeekTextColor() -> UIColor
//    optional func dayOfWeekTextUppercase() -> Bool
//    optional func dayOfWeekFont() -> UIFont
}
