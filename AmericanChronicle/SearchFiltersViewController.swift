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

class SearchFiltersViewController: UIViewController {

    var searchFilters: SearchFilters?

    @IBOutlet weak var earliestDatePickerContainerView: UIView!
    @IBOutlet weak var earliestDatePickerHeight: NSLayoutConstraint!
    @IBOutlet weak var latestDatePickerContainerView: UIView!
    @IBOutlet weak var latestDatePickerHeight: NSLayoutConstraint!
    @IBOutlet weak var earliestDateButton: UIButton!
    @IBOutlet weak var latestDateButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!

    @IBAction func earliestDateButtonTapped(sender: AnyObject) {
        let vc = DatePickerViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func latestDateButtonTapped(sender: AnyObject) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        earliestDatePickerHeight.constant = 0
        latestDatePickerHeight.constant = 0
    }
    

//    func updateLabelsWithCurrentCalendarViewDate() {
//        let now = moment(calendarView.currentMonth)
//        monthButton.setTitle(now.monthName, forState: .Normal)
//        println("will set yearTextField")
//        yearTextField.text = "\(now.year)"
//        println("did set yearTextField")
//    }

    




}
