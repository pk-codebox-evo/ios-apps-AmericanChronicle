//
//  DateTextField.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 2/18/16.
//  Copyright © 2016 ryanipete. All rights reserved.
//

protocol DateTextFieldDelegate {
    func monthFieldDidBecomeActive()
    func dayFieldDidBecomeActive()
    func yearFieldDidBecomeActive()
    func selectedDayMonthYearDidChange(selectedDayMonthYear: DayMonthYear?)
}

class DateTextField: UIView, UITextFieldDelegate {
    var delegate: DateTextFieldDelegate?
    var selectedDayMonthYear: DayMonthYear? {
        didSet {
            monthKeyboard.selectedMonth = selectedDayMonthYear?.month // components month is 1-based.
            monthField.value = selectedDayMonthYear?.monthSymbol

            dayKeyboard.selectedDayMonthYear = selectedDayMonthYear
            dayField.value = (selectedDayMonthYear != nil) ? "\(selectedDayMonthYear!.day)" : ""

            yearPicker.selectedYear = selectedDayMonthYear?.year
            yearField.value = (selectedDayMonthYear != nil) ? "\(selectedDayMonthYear!.year)" : ""
        }
    }

    private let prevNextBar: PrevNextKeyboardAccessoryView = {
        let view = PrevNextKeyboardAccessoryView(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        view.layer.shadowColor = Colors.lightGray.CGColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 0.8
        return view
    }()

    private let pagedKeyboard: PagedKeyboard
    private let monthKeyboard = MonthKeyboard()
    private let dayKeyboard = DayKeyboard()
    private let yearPicker = ByDecadeYearPicker()

    private let monthField = RestrictedInputField(title: "Month")
    private let dayField = RestrictedInputField(title: "Day")
    private let yearField = RestrictedInputField(title: "Year")

    private let normalUnderline: UIImageView = {
        let view = UIImageView(image: UIImage.imageWithFillColor(Colors.lightBlueBrightTransparent))
        return view
    }()

    private let highlightUnderline: UIImageView = {
        let view = UIImageView(image: UIImage.imageWithFillColor(Colors.lightBlueBright))
        return view
    }()

    func commonInit() {

        prevNextBar.previousButtonTapHandler = {
            if self.dayField.isFirstResponder() {
                self.monthField.becomeFirstResponder()
            } else if self.yearField.isFirstResponder() {
                self.dayField.becomeFirstResponder()
            }
        }
        prevNextBar.nextButtonTapHandler = {
            if self.monthField.isFirstResponder() {
                self.dayField.becomeFirstResponder()
            } else if self.dayField.isFirstResponder() {
                self.yearField.becomeFirstResponder()
            }
        }


        monthKeyboard.autoresizingMask = .FlexibleHeight
        monthKeyboard.monthTapHandler = monthValueChanged

        monthField.inputView = pagedKeyboard
        monthField.didBecomeActiveHandler = {
            self.prevNextBar.previousButtonTitle = nil
            self.prevNextBar.nextButtonTitle = "Day"
            self.highlightField(self.monthField)
        }
        addSubview(monthField)
        monthField.snp_makeConstraints { make in
            make.leading.equalTo(0)
            make.top.equalTo(0)
        }

        dayKeyboard.autoresizingMask = .FlexibleHeight
        dayKeyboard.dayTapHandler = dayValueChanged

        dayField.inputView = pagedKeyboard
//        dayField.inputAccessoryView = prevNextBar
        dayField.didBecomeActiveHandler = {
            self.prevNextBar.previousButtonTitle = "Month"
            self.prevNextBar.nextButtonTitle = "Year"
            self.highlightField(self.dayField)
        }
        addSubview(dayField)
        dayField.snp_makeConstraints { make in
            make.leading.equalTo(monthField.snp_trailing).offset(Measurements.horizontalSiblingSpacing)
            make.top.equalTo(0)
            make.width.equalTo(self.monthField.snp_width)
        }

        yearPicker.earliestYear = SearchConstants.earliestPossibleDayMonthYear.year
        yearPicker.latestYear = SearchConstants.latestPossibleDayMonthYear.year
        yearPicker.autoresizingMask = .FlexibleHeight
        yearPicker.yearTapHandler = yearValueChanged

        yearField.inputView = pagedKeyboard
//        yearField.inputAccessoryView = prevNextBar
        yearField.didBecomeActiveHandler = {
            self.prevNextBar.previousButtonTitle = "Day"
            self.prevNextBar.nextButtonTitle = nil
            self.highlightField(self.yearField)
        }
        addSubview(yearField)
        yearField.snp_makeConstraints { make in
            make.leading.equalTo(dayField.snp_trailing).offset(Measurements.horizontalSiblingSpacing)
            make.top.equalTo(0)
            make.width.equalTo(self.dayField.snp_width)
            make.trailing.equalTo(0)
        }

        addSubview(normalUnderline)
        normalUnderline.snp_makeConstraints { make in
            make.top.equalTo(monthField.snp_bottom)
            //make.bottom.equalTo(0)
            make.leading.equalTo(monthField.snp_leading)
            make.trailing.equalTo(yearField.snp_trailing)
            make.height.equalTo(2.0)
            //make.width.equalTo(0)
        }

        addSubview(highlightUnderline)
        highlightUnderline.snp_makeConstraints { make in
            make.top.equalTo(monthField.snp_bottom)
            make.height.equalTo(2.0)
            make.leading.equalTo(monthField.snp_leading)
            make.width.equalTo(monthField.snp_width)
        }
    }

    required init?(coder: NSCoder) {
        pagedKeyboard = PagedKeyboard(pages: [monthKeyboard, dayKeyboard, yearPicker])
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        pagedKeyboard = PagedKeyboard(pages: [monthKeyboard, dayKeyboard, yearPicker])
        super.init(frame: frame)
        self.commonInit()
    }

    func monthValueChanged(value: Int) {
        selectedDayMonthYear = selectedDayMonthYear?.copyWithMonth(value)
        delegate?.selectedDayMonthYearDidChange(selectedDayMonthYear)
    }

    func dayValueChanged(value: String) {
        selectedDayMonthYear = selectedDayMonthYear?.copyWithDay(Int(value) ?? 0)
        delegate?.selectedDayMonthYearDidChange(selectedDayMonthYear)
    }

    func yearValueChanged(value: String) {
        selectedDayMonthYear = selectedDayMonthYear?.copyWithYear(Int(value) ?? 0)
        delegate?.selectedDayMonthYearDidChange(selectedDayMonthYear)
    }

    private func highlightField(field: RestrictedInputField) {
        highlightUnderline.snp_remakeConstraints { make in
            make.height.equalTo(2.0)
            make.top.equalTo(field.snp_bottom)
            make.leading.equalTo(field.snp_leading)
            make.width.equalTo(field.snp_width)
        }
        let pageIndex = [self.monthField, self.dayField, self.yearField].indexOf(field)!
        UIView.animateWithDuration(0.1) {
            self.layoutIfNeeded()
            self.pagedKeyboard.setVisiblePage(pageIndex, animated: false)
        }
    }

    override func becomeFirstResponder() -> Bool {
        return monthField.becomeFirstResponder()
    }
}
