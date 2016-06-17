final class SearchTableHeaderView: UIView {

    // MARK: Properties

    var searchTerm: String? {
        get { return searchField.text }
        set { searchField.text = newValue ?? "" }
    }
    var earliestDate: String? {
        get { return earliestDateButton.value }
        set { earliestDateButton.value = newValue }
    }
    var latestDate: String? {
        get { return latestDateButton.value }
        set { latestDateButton.value = newValue }
    }
    var usStateNames: String? {
        get { return usStatesButton.value }
        set { usStatesButton.value = newValue }
    }
    var shouldChangeCharactersHandler: ((text: String,
                                         range: NSRange,
                                         replacementString: String) -> Bool)? {
        get { return searchField.shouldChangeCharactersHandler }
        set { searchField.shouldChangeCharactersHandler = newValue }
    }
    var shouldReturnHandler: ((Void) -> Bool)? {
        get { return searchField.shouldReturnHandler }
        set { searchField.shouldReturnHandler = newValue }
    }
    var shouldClearHandler: ((Void) -> Bool)? {
        get { return searchField.shouldClearHandler }
        set { searchField.shouldClearHandler = newValue }
    }
    var earliestDateButtonTapHandler: ((Void) -> Void)?
    var latestDateButtonTapHandler: ((Void) -> Void)?
    var usStatesButtonTapHandler: ((Void) -> Void)?

    private let searchField = SearchField()
    private let earliestDateButton = TitleValueButton(title: "Earliest Date")
    private let latestDateButton = TitleValueButton(title: "Latest Date")
    private let usStatesButton = TitleValueButton(title: "U.S. States", initialValue: "(all states)")
    private let bottomBorder = UIImageView(image: UIImage.imageWithFillColor(Colors.lightGray))

    // MARK: Init methods

    func commonInit() {

        backgroundColor = Colors.lightBackground

        addSubview(searchField)
        searchField.snp_makeConstraints { make in
            make.top.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
        searchField.backgroundColor = UIColor.whiteColor()

        earliestDateButton.addTarget(self,
                                     action: #selector(didTapEarliestDateButton(_:)),
                                     forControlEvents: .TouchUpInside)
        addSubview(earliestDateButton)
        earliestDateButton.snp_makeConstraints { make in
            make.top.equalTo(searchField.snp_bottom).offset(8.0)
            make.leading.equalTo(Measurements.horizontalMargin)
        }

        latestDateButton.addTarget(self,
                                   action: #selector(didTapLatestDateButton(_:)),
                                   forControlEvents: .TouchUpInside)
        addSubview(latestDateButton)
        latestDateButton.snp_makeConstraints { make in
            make.top.equalTo(searchField.snp_bottom).offset(8.0)
            make.leading.equalTo(earliestDateButton.snp_trailing)
                        .offset(Measurements.horizontalSiblingSpacing)
            make.trailing.equalTo(-Measurements.horizontalMargin)
            make.width.equalTo(earliestDateButton.snp_width)
        }

        usStatesButton.addTarget(self,
                                 action: #selector(didTapUSStatesButton(_:)),
                                 forControlEvents: .TouchUpInside)
        addSubview(usStatesButton)
        usStatesButton.snp_makeConstraints { make in
            make.top.equalTo(earliestDateButton.snp_bottom)
                    .offset(Measurements.verticalSiblingSpacing)
            make.bottom.equalTo(-10.0)
            make.leading.equalTo(Measurements.horizontalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)
        }

        addSubview(bottomBorder)
        bottomBorder.snp_makeConstraints { make in
            make.bottom.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(1)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    // MARK: Internal methods

    func didTapEarliestDateButton(sender: TitleValueButton) {
        earliestDateButtonTapHandler?()
    }

    func didTapLatestDateButton(sender: TitleValueButton) {
        latestDateButtonTapHandler?()
    }

    func didTapUSStatesButton(sender: TitleValueButton) {
        usStatesButtonTapHandler?()
    }

    // MARK: UIView overrides

    override func intrinsicContentSize() -> CGSize {
        var size = CGSize(width: UIViewNoIntrinsicMetric, height: 0)
        size.height += searchField.intrinsicContentSize().height
        size.height += Measurements.verticalMargin
        size.height += earliestDateButton.intrinsicContentSize().height
        size.height += Measurements.verticalSiblingSpacing
        size.height += usStatesButton.intrinsicContentSize().height
        size.height += Measurements.verticalMargin
        return size
    }

    // MARK: UIResponder overrides

    override func resignFirstResponder() -> Bool {
        return searchField.resignFirstResponder()
    }

    override func becomeFirstResponder() -> Bool {
        return searchField.becomeFirstResponder()
    }
}
