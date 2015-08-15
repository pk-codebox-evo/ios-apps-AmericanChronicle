//
//  SearchFiltersViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/11/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    func update() {
//        yearTextField.text = "\(calendarView.presentedDate.year)"
//        monthButton.setTitle(Month.stringForRawValue(calendarView.presentedDate.month), forState: .Normal)
    }

    @IBAction func monthButtonTapped(sender: AnyObject) {
        showMonthPicker()
    }

    func showMonthPicker() {
        let vc = MonthPickerViewController(nibName: "MonthPickerViewController", bundle: nil)
        vc.modalPresentationStyle = .OverFullScreen
//        vc.selectedMonth = Month(rawValue: calendarView.presentedDate.month)
        vc.didSelectMonthCallback = { [weak self] month in
//            if let month = month, year = self?.calendarView.presentedDate.year {
//                self?.updateCalendar(month.rawValue, year: year)
//            }
            self?.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(vc, animated: true, completion: nil)
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var updatedText = textField.text as NSString
        updatedText = updatedText.stringByReplacingCharactersInRange(range, withString: string)
        if textField == yearTextField {
            if let year = (updatedText as String).toInt() where year >= 1836 && year <= 1922 {
//                updateCalendar(calendarView.presentedDate.month, year: year)
            }
        }
        return true
    }

    // MARK: FSCalendarDelegate methods

    func calendar(calendar: FSCalendar, shouldSelectDate: NSDate) -> Bool {
        return true
    }

    func calendar(calendar: FSCalendar, didSelectDate: NSDate) {

    }

    func calendarCurrentMonthDidChange(calendar: FSCalendar) {
        println("calendar: \(calendar)")
        println("calendar.currentMonth: \(calendar.currentMonth)")
    }

    // MARK: FSCalendarDataSource methods

    func calendar(calendar: FSCalendar, subtitleForDate: NSDate) -> String {
        return ""
    }

    func calendar(calendar: FSCalendar, imageForDate: NSDate) -> UIImage {
        return UIImage()
    }

    func calendar(calendar: FSCalendar, hasEventForDate: NSDate) -> Bool {
        return true
    }

    func minimumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return NSDate()
    }

    func maximumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return NSDate().dateByAddingTimeInterval(60*60*24*365)
    }
}
