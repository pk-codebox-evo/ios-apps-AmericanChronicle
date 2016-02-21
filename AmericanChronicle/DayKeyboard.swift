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
        didSet {
            updateCalendar()
        }
    }

    func commonInit() {
        backgroundColor = Colors.lightBackground

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    private func updateCalendar() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
        guard let selectedDayMonthYear = selectedDayMonthYear else { return }

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
            make.bottom.equalTo(self.snp_bottom)
        }

        for subview in subviews {
            if let button = subview as? UIButton, let title = button.titleForState(.Normal), day = Int(title) {
                button.selected = (day == selectedDayMonthYear.day)
            }
        }
    }


    func buttonTapped(button: UIButton) {
        if let title = button.titleForState(.Normal) {
            dayTapHandler?(title)
        }
    }

    private func addRowWithTitles(titles: [String], prevRow: UIButton? = nil) -> UIButton? {
        var prevColumn: UIButton? = nil
        for title in titles {
            let button = UIButton()
            button.setBackgroundImage(UIImage.imageWithFillColor(Colors.lightBlueBright, borderColor: Colors.lightBlueBright), forState: .Selected)
            button.setBackgroundImage(UIImage.imageWithFillColor(Colors.lightBlueBright, borderColor: Colors.lightBlueBright), forState: .Highlighted)
            button.setTitle(title, forState: .Normal)
            button.setTitleColor(Colors.darkGray, forState: .Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            button.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            button.titleLabel?.font = Font.largeBody
            if title == "" {
                button.enabled = false
            }

            button.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
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
                make.leading.equalTo(leading)
                make.top.equalTo(top)
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
            make.trailing.equalTo(self.snp_trailing)
        }
        return prevColumn
    }

}
