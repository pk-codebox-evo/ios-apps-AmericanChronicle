//
//  VerticalStripCell.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 6/9/16.
//  Copyright © 2016 ryanipete. All rights reserved.
//

import UIKit

class VerticalStripCell: UICollectionViewCell {
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.textColor = Colors.darkBlue
        label.font = Font.largeBody
        return label
    }()

    var text: String? {
        get { return label.text }
        set { label.text = newValue }
    }

    func commonInit() {
        backgroundColor = UIColor.whiteColor()
        label.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        label.frame = bounds
        addSubview(label)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
}
