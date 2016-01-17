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
    var selectedDate: NSDate { get set }
}

@objc protocol DatePickerViewDelegate {
    func userDidSave(date: NSDate)
    func userDidCancel()
}

@objc class DatePickerViewController: UIViewController, DatePickerViewInterface {

    weak var delegate: DatePickerViewDelegate?

    var selectedDate: NSDate {
        didSet {
            datePicker.date = selectedDate
        }
    }
    
    private let earliestPossibleDate: NSDate
    private let latestPossibleDate: NSDate
    private let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()
    private lazy var dateLabel: UILabel! = {
        let label = UILabel()
        label.textAlignment = .Center
        return label
    }()
    private lazy var datePicker = UIDatePicker()

    // MARK: UIViewController Init methods

    internal init(
        earliestPossibleDate: NSDate = SearchConstants.earliestPossibleDate(),
        latestPossibleDate: NSDate = SearchConstants.latestPossibleDate())
    {
        self.earliestPossibleDate = earliestPossibleDate
        self.latestPossibleDate = latestPossibleDate
        selectedDate = earliestPossibleDate

        super.init(nibName: nil, bundle: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelButtonTapped:")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveButtonTapped:")
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
        delegate?.userDidSave(datePicker.date)
    }

    func cancelButtonTapped(sender: UIBarButtonItem) {
        delegate?.userDidCancel()
    }

    func updateLabelToMatchPicker() {
        dateLabel.text = dateFormatter.stringFromDate(datePicker.date)
    }

    // MARK: UIViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()

        view.addSubview(dateLabel)
        dateLabel.snp_makeConstraints { make in
             make.top.equalTo(self.snp_topLayoutGuideBottom).offset(Measurements.verticalMargin)
             make.leading.equalTo(Measurements.horizontalMargin)
             make.trailing.equalTo(-Measurements.horizontalMargin)
        }

        datePicker.addTarget(self, action: "datePickerValueChanged:", forControlEvents: .ValueChanged)
        datePicker.datePickerMode = .Date
        view.addSubview(datePicker)
        datePicker.snp_makeConstraints { make in
             make.bottom.equalTo(0)
             make.leading.equalTo(0)
             make.trailing.equalTo(0)
        }
        datePicker.minimumDate = earliestPossibleDate
        datePicker.maximumDate = latestPossibleDate
        datePicker.date = selectedDate

        updateLabelToMatchPicker()
    }

    func datePickerValueChanged(sender: UIDatePicker) {
        updateLabelToMatchPicker()
    }
}
