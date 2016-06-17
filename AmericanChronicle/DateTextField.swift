protocol DateTextFieldDelegate: class {
    func selectedDayMonthYearDidChange(selectedDayMonthYear: DayMonthYear?)
}

final class DateTextField: UIView, UITextFieldDelegate {

    // MARK: Properties

    weak var delegate: DateTextFieldDelegate?
    var selectedDayMonthYear: DayMonthYear? {
        didSet {
            // components month is 1-based.
            monthKeyboard.selectedMonth = selectedDayMonthYear?.month
            monthField.value = selectedDayMonthYear?.monthSymbol

            dayKeyboard.selectedDayMonthYear = selectedDayMonthYear
            dayField.value = (selectedDayMonthYear != nil) ? "\(selectedDayMonthYear!.day)" : ""

            yearPicker.selectedYear = selectedDayMonthYear?.year
            yearField.value = (selectedDayMonthYear != nil) ? "\(selectedDayMonthYear!.year)" : ""
        }
    }

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

    // MARK: Init methods

    func commonInit() {

        monthKeyboard.autoresizingMask = .FlexibleHeight
        monthKeyboard.monthTapHandler = monthValueChanged

        monthField.inputView = pagedKeyboard
        monthField.didBecomeActiveHandler = {
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
        dayField.didBecomeActiveHandler = {
            self.highlightField(self.dayField)
        }
        addSubview(dayField)
        dayField.snp_makeConstraints { make in
            make.leading.equalTo(monthField.snp_trailing)
                .offset(Measurements.horizontalSiblingSpacing)
            make.top.equalTo(0)
            make.width.equalTo(self.monthField.snp_width)
        }

        yearPicker.earliestYear = Search.earliestPossibleDayMonthYear.year
        yearPicker.latestYear = Search.latestPossibleDayMonthYear.year
        yearPicker.autoresizingMask = .FlexibleHeight
        yearPicker.yearTapHandler = yearValueChanged

        yearField.inputView = pagedKeyboard
        yearField.didBecomeActiveHandler = {
            self.highlightField(self.yearField)
        }
        addSubview(yearField)
        yearField.snp_makeConstraints { make in
            make.leading.equalTo(dayField.snp_trailing).offset(Measurements.horizontalSiblingSpacing)
            make.top.equalTo(0)
            make.width.equalTo(dayField.snp_width)
            make.trailing.equalTo(0)
        }

        addSubview(normalUnderline)
        normalUnderline.snp_makeConstraints { make in
            make.top.equalTo(monthField.snp_bottom)
            make.leading.equalTo(monthField.snp_leading)
            make.trailing.equalTo(yearField.snp_trailing)
            make.height.equalTo(2.0)
        }

        addSubview(highlightUnderline)
        highlightUnderline.snp_makeConstraints { make in
            make.top.equalTo(monthField.snp_bottom)
            make.height.equalTo(2.0)
            make.leading.equalTo(monthField.snp_leading)
            make.width.equalTo(monthField.snp_width)
        }
    }

    override init(frame: CGRect) {
        pagedKeyboard = PagedKeyboard(pages: [monthKeyboard, dayKeyboard, yearPicker])
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        pagedKeyboard = PagedKeyboard(pages: [monthKeyboard, dayKeyboard, yearPicker])
        super.init(coder: coder)
        self.commonInit()
    }

    // MARK: Internal methods

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

    // MARK: Private methods

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

    // MARK: UIResponder overrides

    override func becomeFirstResponder() -> Bool {
        return monthField.becomeFirstResponder()
    }
}
