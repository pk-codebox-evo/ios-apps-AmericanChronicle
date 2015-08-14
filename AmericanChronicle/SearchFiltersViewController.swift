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
    @IBOutlet weak var monthButton: UIButton!
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
        update()
    }

    func update() {
        yearTextField.text = "\(calendarView.presentedDate.year)"
        monthButton.setTitle(Month.stringForRawValue(calendarView.presentedDate.month), forState: .Normal)
    }

    @IBAction func monthButtonTapped(sender: AnyObject) {
        showMonthPicker()
    }

    func showMonthPicker() {
        let vc = MonthPickerViewController(nibName: "MonthPickerViewController", bundle: nil)
        vc.modalPresentationStyle = .OverFullScreen
        vc.selectedMonth = Month(rawValue: calendarView.presentedDate.month)
        vc.didSelectMonthCallback = { [weak self] month in
            self?.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(vc, animated: true, completion: nil)
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var updatedText = textField.text as NSString
        updatedText = updatedText.stringByReplacingCharactersInRange(range, withString: string)
        if textField == yearTextField {
            if let year = (updatedText as String).toInt() where year >= 1836 && year <= 1922 {
                calendarView.toggleViewWithDate(Date(day: calendarView.presentedDate.day, month: calendarView.presentedDate.month, week: calendarView.presentedDate.week, year: year).convertedDate()!)
            }
        }
        return true
    }

    func presentationMode() -> CalendarMode {
        return CalendarMode.MonthView
    }
    func firstWeekday() -> Weekday {
        return Weekday.Sunday
    }

    func didSelectDayView(dayView: DayView) {
        update()
    }
}
