//
//  SearchTableHeaderView.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 1/17/16.
//  Copyright © 2016 ryanipete. All rights reserved.
//

class SearchTableHeaderView: UIView {

    var searchTerm: String? {
        get {
            return searchField.text
        }
        set {
            searchField.text = newValue ?? ""
        }
    }

    var earliestDate: String? {
        get {
            return earliestDateButton.value
        }
        set {
            earliestDateButton.value = newValue
        }
    }

    var latestDate: String? {
        get {
            return latestDateButton.value
        }
        set {
            latestDateButton.value = newValue
        }
    }

    var USStates: String? {
        get {
            return USStatesButton.value
        }
        set {
            USStatesButton.value = newValue
        }
    }

    var shouldChangeCharactersHandler: ((text: String, range: NSRange, replacementString: String) -> Bool)? {
        get {
            return searchField.shouldChangeCharactersHandler
        }
        set {
            searchField.shouldChangeCharactersHandler = newValue
        }
    }

    var shouldReturnHandler: ((Void) -> Bool)? {
        get {
            return searchField.shouldReturnHandler
        }
        set {
            searchField.shouldReturnHandler = newValue
        }
    }

    var shouldClearHandler: ((Void) -> Bool)? {
        get {
            return searchField.shouldClearHandler
        }
        set {
            searchField.shouldClearHandler = newValue
        }
    }

    var earliestDateButtonTapHandler: ((Void) -> Void)?
    var latestDateButtonTapHandler: ((Void) -> Void)?
    var USStatesButtonTapHandler: ((Void) -> Void)?

    private let searchField = SearchField()
    private let earliestDateButton = TitleValueButton()
    private let latestDateButton = TitleValueButton()
    private let USStatesButton = TitleValueButton()

    func commonInit() {

        backgroundColor = Colors.lightBackground

        addSubview(searchField)
        searchField.snp_makeConstraints { make in
            make.top.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
        searchField.backgroundColor = UIColor.whiteColor()

        earliestDateButton.title = "Earliest Date"
        earliestDateButton.value = "--"
        earliestDateButton.addTarget(self, action: "earliestDateButtonTapped:", forControlEvents: .TouchUpInside)
        addSubview(earliestDateButton)
        earliestDateButton.snp_makeConstraints { make in
            make.top.equalTo(searchField.snp_bottom).offset(Measurements.verticalMargin)
            make.leading.equalTo(Measurements.horizontalMargin)
        }

        latestDateButton.title = "Latest Date"
        latestDateButton.value = "--"
        latestDateButton.addTarget(self, action: "latestDateButtonTapped:", forControlEvents: .TouchUpInside)
        addSubview(latestDateButton)
        latestDateButton.snp_makeConstraints { make in
            make.top.equalTo(searchField.snp_bottom).offset(Measurements.verticalMargin)
            make.leading.equalTo(earliestDateButton.snp_trailing).offset(Measurements.horizontalSiblingSpacing)
            make.trailing.equalTo(-Measurements.horizontalMargin)
            make.width.equalTo(earliestDateButton.snp_width)
        }

        USStatesButton.title = "U.S. States"
        USStatesButton.value = "(all states)"
        USStatesButton.addTarget(self, action: "USStatesButtonTapped:", forControlEvents: .TouchUpInside)
        addSubview(USStatesButton)
        USStatesButton.snp_makeConstraints { make in
            make.top.equalTo(earliestDateButton.snp_bottom).offset(Measurements.verticalSiblingSpacing)
            make.bottom.equalTo(-Measurements.verticalMargin)
            make.leading.equalTo(Measurements.horizontalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    override func intrinsicContentSize() -> CGSize {
        var size = CGSize(width: UIViewNoIntrinsicMetric, height: 0)
        size.height += searchField.intrinsicContentSize().height
        size.height += Measurements.verticalMargin
        size.height += earliestDateButton.intrinsicContentSize().height
        size.height += Measurements.verticalSiblingSpacing
        size.height += USStatesButton.intrinsicContentSize().height
        size.height += Measurements.verticalMargin
        return size
    }

    override func resignFirstResponder() -> Bool {
        return searchField.resignFirstResponder()
    }

    override func becomeFirstResponder() -> Bool {
        return searchField.becomeFirstResponder()
    }

    func earliestDateButtonTapped(sender: TitleValueButton) {
        earliestDateButtonTapHandler?()
    }

    func latestDateButtonTapped(sender: TitleValueButton) {
        latestDateButtonTapHandler?()
    }

    func USStatesButtonTapped(sender: TitleValueButton) {
        USStatesButtonTapHandler?()
    }
}
