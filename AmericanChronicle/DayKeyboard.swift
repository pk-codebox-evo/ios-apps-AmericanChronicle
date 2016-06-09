//
//  DayKeyboard.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 2/21/16.
//  Copyright © 2016 ryanipete. All rights reserved.
//

import UIKit
import SnapKit

class DayKeyboard: UIView {

    var dayTapHandler: ((String) -> Void)?
    var selectedDayMonthYear: DayMonthYear? {
        didSet { updateCalendar() }
    }

    // MARK: Init methods

    func commonInit() {
        backgroundColor = Colors.darkBlue
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    // MARK: Internal methods

    func buttonTapped(button: UIButton) {
        if let title = button.titleForState(.Normal) {
            dayTapHandler?(title)
        }
    }

    // MARK: Private methods

    private func updateCalendar() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
        guard let selectedDayMonthYear = selectedDayMonthYear else { return }
        Reporter.sharedInstance.logMessage("selectedDayMonthYear: %@", arguments: [selectedDayMonthYear.description])
        guard let rangeOfDaysThisMonth = selectedDayMonthYear.rangeOfDaysInMonth() else { return }
        var weeks: [[Int?]] = []
        for day in (1...rangeOfDaysThisMonth.length) {
            let dayMonthYear = selectedDayMonthYear.copyWithDay(day)
            guard let weekday = dayMonthYear.weekday else { continue }
            guard let weeknumber = dayMonthYear.weekOfMonth else { continue }
            let zeroBasedWeekNumber = weeknumber - 1
            if weeks.count == zeroBasedWeekNumber {
                weeks.append([Int?](count: 7, repeatedValue: nil))
            }
            weeks[zeroBasedWeekNumber][(weekday - 1)] = day
        }
        var prevRow: UIButton?
        for week in weeks {
            let dayStrings = week.map { ($0 != nil) ? "\($0!)" : "" }
            prevRow = addRowWithTitles(dayStrings, prevRow: prevRow)

        }
        prevRow?.snp_makeConstraints { make in
            make.bottom.equalTo(self.snp_bottom).offset(-1.0)
        }

        for subview in subviews {
            if let button = subview as? UIButton, let title = button.titleForState(.Normal), day = Int(title) {
                button.selected = (day == selectedDayMonthYear.day)
            }
        }
    }

    private func addRowWithTitles(titles: [String], prevRow: UIButton? = nil) -> UIButton? {
        let selectedBgColor = Colors.lightBlueBright
        let normalBgColor = Colors.lightBlueBrightTransparent

        var prevColumn: UIButton? = nil
        for title in titles {
            let button = UIButton()
            button.setTitle(title, forState: .Normal)
            button.titleLabel?.font = Font.largeBody
            button.enabled = (title != "")

            button.setBackgroundImage(UIImage.imageWithFillColor(normalBgColor), forState: .Normal)
            button.setBackgroundImage(UIImage.imageWithFillColor(UIColor.clearColor()), forState: .Disabled)
            button.setBackgroundImage(UIImage.imageWithFillColor(selectedBgColor), forState: .Selected)
            button.setBackgroundImage(UIImage.imageWithFillColor(selectedBgColor), forState: .Highlighted)
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            button.setTitleColor(UIColor.whiteColor(), forState: .Selected)

            button.addTarget(self, action: #selector(DayKeyboard.buttonTapped(_:)), forControlEvents: .TouchUpInside)
            addSubview(button)

            let leading: ConstraintItem
            if let prevColumn = prevColumn {
                leading = prevColumn.snp_trailing
            } else {
                leading = self.snp_leading
            }
            let top: ConstraintItem
            if let prevRow = prevRow {
                top = prevRow.snp_bottom
            } else {
                top = self.snp_top
            }
            button.snp_makeConstraints { make in
                make.leading.equalTo(leading).offset(1.0)
                make.top.equalTo(top).offset(1.0)
                if let width = prevColumn?.snp_width {
                    make.width.equalTo(width)
                }
                if let height = prevRow?.snp_height {
                    make.height.equalTo(height)
                } else if let height = prevColumn?.snp_height {
                    make.height.equalTo(height)
                }
            }
            prevColumn = button
        }

        prevColumn?.snp_makeConstraints { make in
            make.trailing.equalTo(self.snp_trailing).offset(-1.0)
        }
        return prevColumn
    }
}
