//
//  NewspaperIssueCell.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/27/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class NewspaperIssueCell: UICollectionViewCell {
    @IBInspectable var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    @IBInspectable var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    @IBInspectable var unselectedBorderColor: UIColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    @IBInspectable var selectedBorderColor: UIColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .ScaleAspectFill
        iv.layer.borderWidth = 2.0
        return iv
        }()
    let titleLabel: UILabel = {
        let l = UILabel()
        l.backgroundColor = UIColor(white: 0, alpha: 0.8)
        l.textColor = UIColor.whiteColor()
        l.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
        l.textAlignment = .Center
        l.numberOfLines = 0
        return l
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        println("\(__FILE__) | \(__FUNCTION__) | line \(__LINE__)")
        for subview in [imageView, titleLabel] {
            subview.setTranslatesAutoresizingMaskIntoConstraints(false)
            addSubview(subview)
        }

        imageView.image = image
        titleLabel.text = title


        imageView.snp_makeConstraints { make in
            make.top.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(0)
        }

        titleLabel.snp_makeConstraints { make in
            make.top.equalTo(10.0)
            make.leading.equalTo(10.0)
            make.trailing.equalTo(-10.0)
            make.height.equalTo(30.0)
        }

    }

    override var selected: Bool {
        didSet {
            imageView.layer.borderColor = selected ? selectedBorderColor.CGColor : unselectedBorderColor.CGColor
        }
    }
}

