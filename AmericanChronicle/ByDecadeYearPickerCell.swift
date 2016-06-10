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

    private let insetBackgroundView = UIImageView(image: UIImage.imageWithFillColor(UIColor.whiteColor(), cornerRadius: 1.0))

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


        contentView.addSubview(insetBackgroundView)
        insetBackgroundView.snp_makeConstraints { make in
            make.edges.equalTo(contentView.snp_edges).inset(1.0)
            //make.top.equalTo(0)
            //make.bottom.equalTo(0)
            //make.leading.equalTo(0)
            //make.trailing.equalTo(0)
            //make.height.equalTo(0)
            //make.width.equalTo(0)
        }

        insetBackgroundView.layer.shadowColor = Colors.darkGray.CGColor
        insetBackgroundView.layer.shadowOpacity = 0.3
        insetBackgroundView.layer.shadowRadius = 0.5
        insetBackgroundView.layer.shadowOffset = CGSizeZero

        label.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        label.frame = bounds
        contentView.addSubview(label)

        updateFormat()
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
//            self.contentView.backgroundColor = Colors.lightBlueBrightTransparent
            insetBackgroundView.image = UIImage.imageWithFillColor(Colors.lightBlueBright, cornerRadius: 1.0)
            self.label.textColor = UIColor.whiteColor()
        } else if self.selected {
            insetBackgroundView.image = UIImage.imageWithFillColor(Colors.lightBlueBright, cornerRadius: 1.0)
//            self.contentView.backgroundColor = Colors.lightBlueBright
            self.label.textColor = UIColor.whiteColor()
        } else {
            insetBackgroundView.image = UIImage.imageWithFillColor(UIColor.whiteColor(), cornerRadius: 1.0)
//            self.contentView.backgroundColor = UIColor.whiteColor()
            self.label.textColor = Colors.darkBlue
        }
    }
}
