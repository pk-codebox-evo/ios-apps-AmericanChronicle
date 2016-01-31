//
//  TitleValueButton.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 1/3/16.
//  Copyright © 2016 ryanipete. All rights reserved.
//

import Foundation

class TitleValueButton: UIControl {

    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var value: String? {
        get { return valueLabel.text }
        set { valueLabel.text = newValue }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.lightGray
        label.highlightedTextColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(12.0)
        return label
    }()
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.lightBlueBright
        label.highlightedTextColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(14.0)
        label.textAlignment = .Center
        return label
    }()
    private let button = UIButton()

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        highlighted = button.highlighted
    }

    func commonInit() {
        button.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
        button.addObserver(self, forKeyPath: "highlighted", options: NSKeyValueObservingOptions.Initial, context: nil)

        addSubview(button)
        addSubview(titleLabel)
        addSubview(valueLabel)

        button.snp_makeConstraints { make in
            make.edges.equalTo(self)
        }

        titleLabel.snp_makeConstraints { make in
            make.top.equalTo(5)
            make.leading.equalTo(8)
            make.trailing.equalTo(-8)
        }

        valueLabel.snp_makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp_bottom).offset(4)
            make.leading.equalTo(8)
            make.trailing.equalTo(-8)
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

    override var highlighted: Bool {
        didSet {
            titleLabel.highlighted = highlighted
            valueLabel.highlighted = highlighted
        }
    }

    func buttonTapped(sender: UIButton) {
        sendActionsForControlEvents(.TouchUpInside)
    }

    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: Measurements.buttonHeight)
    }
}