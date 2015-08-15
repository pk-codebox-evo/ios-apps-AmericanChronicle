//
//  SearchFiltersViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/11/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import SwiftMoment
import FSCalendar

extension UIViewController {
    func setChildViewController(viewController : UIViewController, inContainer containerView: UIView) {
        if let onlyChild = self.childViewControllers.first as? UIViewController {
            onlyChild.willMoveToParentViewController(nil)
            onlyChild.view.removeFromSuperview()
            onlyChild.removeFromParentViewController()
        }

        self.addChildViewController(viewController)
        viewController.view.frame = containerView.bounds
        containerView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
    }
}

class SearchFiltersViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {

    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var calendarContainerView: UIView!
    @IBOutlet weak var calendarView: FSCalendar!

    @IBAction func monthButtonTapped(sender: AnyObject) {
        showMonthPicker()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.selectedDate = minimumDateForCalendar(calendarView)
    }

    func showMonthPicker() {
        let vc = MonthPickerViewController(nibName: "MonthPickerViewController", bundle: nil)
        vc.modalPresentationStyle = .OverFullScreen
        vc.didSelectMonthCallback = { [weak self] month in
            if let month = month {
                self?.setCalendarDate(month: month.rawValue)
            }
            self?.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(vc, animated: true, completion: nil)
    }

    func setCalendarDate(year: Int? = nil, month: Int? = nil) {

        if let year = year {
            println("will set year")
            calendarView.selectedDate = NSCalendar.currentCalendar().dateBySettingUnit(.CalendarUnitYear, value: year, ofDate: calendarView.selectedDate, options: NSCalendarOptions.allZeros)
            println("did set year")
        }
        if let month = month {
            println("will set month")
            calendarView.selectedDate = NSCalendar.currentCalendar().dateBySettingUnit(.CalendarUnitMonth, value: month, ofDate: calendarView.selectedDate, options: NSCalendarOptions.allZeros)
            println("did set month")
        }
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        println("enter shouldChangeCharactersInRange")
        var updatedText = textField.text as NSString
        updatedText = updatedText.stringByReplacingCharactersInRange(range, withString: string)
        if textField == yearTextField {
            if let year = (updatedText as String).toInt() {
                if year >= 1836 && year <= 1922 {
                    setCalendarDate(year: year)
                    return false
                } else {
                    return true
                }
            } else {
                return false
            }
        }
        println("exit shouldChangeCharactersInRange")
        return true
    }

    // MARK: FSCalendarDelegate methods

    func calendar(calendar: FSCalendar, shouldSelectDate: NSDate) -> Bool {
        return false
    }

    func calendar(calendar: FSCalendar, didSelectDate: NSDate) {

    }

    func calendarCurrentMonthDidChange(calendar: FSCalendar) {
        let now = moment(calendar.currentMonth)
        monthButton.setTitle(now.monthName, forState: .Normal)
        println("will set yearTextField")
        yearTextField.text = "\(now.year)"
        println("did set yearTextField")
    }

    // MARK: FSCalendarDataSource methods

    func calendar(calendar: FSCalendar, subtitleForDate: NSDate) -> String {
        return ""
    }

    func calendar(calendar: FSCalendar, imageForDate: NSDate) -> UIImage {
        return UIImage()
    }

    func calendar(calendar: FSCalendar, hasEventForDate: NSDate) -> Bool {
        return false
    }

    func minimumDateForCalendar(calendar: FSCalendar) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.year = 1836
        return calendar.dateFromComponents(components)!
    }

    func maximumDateForCalendar(calendar: FSCalendar) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.year = 1923
        return calendar.dateFromComponents(components)!
    }
}
