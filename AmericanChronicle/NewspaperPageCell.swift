//
//  NewspaperPageCell.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/9/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class NewspaperPageCell: UICollectionViewCell {
    @IBInspectable var image: UIImage?
    @IBInspectable var selectedBorderColor: UIColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .ScaleAspectFill
        return iv
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.image = image
        self.addSubview(imageView)
    }

    override var selected: Bool {
        didSet {
            imageView.layer.borderColor = selected ? selectedBorderColor.CGColor : nil
            imageView.layer.borderWidth = selected ? 2.0 : 0
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRectInset(bounds, 0, 0)
    }
}
