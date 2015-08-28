//
//  NewspaperIssueCell.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/27/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class NewspaperIssueCell: UICollectionViewCell {
    @IBInspectable var image: UIImage?
    @IBInspectable var unselectedBorderColor: UIColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    @IBInspectable var selectedBorderColor: UIColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .ScaleAspectFill
        iv.layer.borderWidth = 2.0
        return iv
        }()

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.image = image

        self.addSubview(imageView)
    }

    override var selected: Bool {
        didSet {
            imageView.layer.borderColor = selected ? selectedBorderColor.CGColor : unselectedBorderColor.CGColor
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRectInset(bounds, 0, 0)
    }
}

