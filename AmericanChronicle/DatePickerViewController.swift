//
//  DatePickerViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/15/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import FSCalendar

protocol DatePickerViewInterface {
    var delegate: DatePickerViewDelegate? { get set }
    var selectedDayMonthYear: DayMonthYear { get set }
}

protocol DatePickerViewDelegate {
    func userDidSave(dayMonthYear: DayMonthYear)
    func userDidCancel()
}

@objc class DatePickerViewController: UIViewController, DatePickerViewInterface, DateTextFieldDelegate {

    var delegate: DatePickerViewDelegate?

    var selectedDayMonthYear: DayMonthYear
    private let earliestPossibleDayMonthYear: DayMonthYear
    private let latestPossibleDayMonthYear: DayMonthYear
    private let dateField = DateTextField()
    private let hintLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mediumBody
        label.textAlignment = .Center
        return label
    }()

    // MARK: UIViewController Init methods

    internal init(
        earliestPossibleDayMonthYear: DayMonthYear = SearchConstants.earliestPossibleDayMonthYear,
        latestPossibleDayMonthYear: DayMonthYear = SearchConstants.latestPossibleDayMonthYear)
    {
        self.earliestPossibleDayMonthYear = earliestPossibleDayMonthYear
        self.latestPossibleDayMonthYear = latestPossibleDayMonthYear
        selectedDayMonthYear = earliestPossibleDayMonthYear

        super.init(nibName: nil, bundle: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelButtonTapped:")
        navigationItem.leftBarButtonItem?.setTitlePositionAdjustment(Measurements.leftBarButtonItemTitleAdjustment, forBarMetrics: .Default)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonTapped:")
        navigationItem.rightBarButtonItem?.setTitlePositionAdjustment(Measurements.rightBarButtonItemTitleAdjustment, forBarMetrics: .Default)
    }

    @available(*, unavailable) init() {
        fatalError("init not supported. Use designated initializer instead")
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported. Use designated initializer instead")
    }

    @available(*, unavailable) override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        fatalError("init(nibName:bundle) not supported. Use designated initializer instead")
    }

    // MARK: Internal methods

    func saveButtonTapped(sender: UIBarButtonItem) {
        delegate?.userDidSave(selectedDayMonthYear)
    }

    func cancelButtonTapped(sender: UIBarButtonItem) {
        delegate?.userDidCancel()
    }

    // MARK: UIViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        dateField.delegate = self
        dateField.selectedDayMonthYear = selectedDayMonthYear
        view.addSubview(dateField)
        dateField.snp_makeConstraints { make in
            make.top.equalTo(self.snp_topLayoutGuideBottom).offset(Measurements.verticalMargin)
            make.leading.equalTo(Measurements.horizontalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)
            make.height.equalTo(66)
        }

        view.addSubview(hintLabel)
        hintLabel.snp_makeConstraints { make in
            make.leading.equalTo(Measurements.horizontalMargin)
            make.top.equalTo(dateField.snp_bottom).offset(Measurements.verticalSiblingSpacing)
            make.trailing.equalTo(-Measurements.horizontalMargin)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        dateField.becomeFirstResponder()
    }

    func monthFieldDidBecomeActive() {
        hintLabel.text = "Month label is active"
    }

    func dayFieldDidBecomeActive() {
        hintLabel.text = "Day label is active"
    }

    func yearFieldDidBecomeActive() {
        hintLabel.text = "Year label is active"
    }

    func selectedDayMonthYearDidChange(dayMonthYear: DayMonthYear?) {
        if let dayMonthYear = dayMonthYear {
            selectedDayMonthYear = dayMonthYear
        }
    }
}
