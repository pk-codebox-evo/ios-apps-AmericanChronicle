//
//  DatePickerViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/15/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

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
    private let foregroundPanel: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.whiteColor()
        return v
    }()
    private let earliestPossibleDayMonthYear: DayMonthYear
    private let latestPossibleDayMonthYear: DayMonthYear
    private let dateField = DateTextField()
    private let navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        return bar
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

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel,
                                                           target: self,
                                                           action: #selector(DatePickerViewController.cancelButtonTapped(_:)))
        navigationItem.leftBarButtonItem?.setTitlePositionAdjustment(Measurements.leftBarButtonItemTitleAdjustment, forBarMetrics: .Default)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(DatePickerViewController.saveButtonTapped(_:)))
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

    func tapRecognized(sender: UITapGestureRecognizer) {
        delegate?.userDidCancel()
    }

    // MARK: UIViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        let tap = UITapGestureRecognizer(target: self, action: #selector(DatePickerViewController.tapRecognized(_:)))
        view.addGestureRecognizer(tap)

        view.addSubview(foregroundPanel)
        foregroundPanel.snp_makeConstraints { make in
            make.bottom.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(360)
        }


        foregroundPanel.addSubview(navigationBar)
        navigationBar.snp_makeConstraints { make in
            make.top.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
        navigationBar.pushNavigationItem(navigationItem, animated: false)

        dateField.delegate = self
        dateField.selectedDayMonthYear = selectedDayMonthYear
        foregroundPanel.addSubview(dateField)
        dateField.snp_makeConstraints { make in
            make.top.equalTo(navigationBar.snp_bottom).offset(20.0)
            make.leading.equalTo(Measurements.horizontalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)
            make.height.equalTo(66)
        }


    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        dateField.becomeFirstResponder()
    }

    func monthFieldDidBecomeActive() {
    }

    func dayFieldDidBecomeActive() {
    }

    func yearFieldDidBecomeActive() {
    }

    func selectedDayMonthYearDidChange(dayMonthYear: DayMonthYear?) {
        if let dayMonthYear = dayMonthYear {
            selectedDayMonthYear = dayMonthYear
        }
    }
}
