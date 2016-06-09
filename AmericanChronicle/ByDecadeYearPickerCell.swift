//
//  ByDecadeYearPickerCell.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 5/28/16.
//  Copyright © 2016 ryanipete. All rights reserved.
//

import UIKit

class ByDecadeYearPickerCell: UICollectionViewCell {

    static let defaultReuseIdentifier = "ByDecadeYearPickerCell"

    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.font = Font.largeBody
        label.textColor = Colors.darkGray
        return label
    }()

    var text: String? {
        get { return label.text }
        set { label.text = newValue }
    }

    override var highlighted: Bool {
        didSet {
            updateFormat()
        }
    }

    override var selected: Bool {
        didSet {
            updateFormat()
        }
    }

    func commonInit() {
        label.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        label.frame = bounds
        addSubview(label)
        updateFormat()

        layer.cornerRadius = 1.0
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    private func updateFormat() {
        if self.highlighted {
            self.contentView.backgroundColor = Colors.lightBlueBright
            self.label.textColor = UIColor.whiteColor()
        } else if self.selected {
            self.contentView.backgroundColor = Colors.lightBlueBright
            self.label.textColor = UIColor.whiteColor()
        } else {
            self.contentView.backgroundColor = Colors.lightBlueBrightTransparent
            self.label.textColor = UIColor.whiteColor()
        }
    }
}
