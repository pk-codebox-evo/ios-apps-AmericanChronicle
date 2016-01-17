//
//  Style.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/30/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class TopMarginConstraint: NSLayoutConstraint {
    override var constant: CGFloat {
        get { return Measurements.verticalMargin }
        set {}
    }
}

class BottomMarginConstraint: NSLayoutConstraint {
    override var constant: CGFloat {
        get { return -Measurements.verticalMargin }
        set {}
    }
}

class LeadingMarginConstraint: NSLayoutConstraint {
    override var constant: CGFloat {
        get { return Measurements.horizontalMargin }
        set {}
    }
}

class TrailingMarginConstraint: NSLayoutConstraint {
    override var constant: CGFloat {
        get { return -Measurements.horizontalMargin }
        set {}
    }
}

class ButtonHeightConstraint: NSLayoutConstraint {
    override var constant: CGFloat {
        get { return Measurements.buttonHeight }
        set {}
    }
}

struct Measurements {
    static let verticalMargin: CGFloat = 16.0
    static let horizontalMargin: CGFloat = 24.0
    static let buttonHeight: CGFloat = 48.0

    static let verticalSiblingSpacing: CGFloat = 16.0
    static let horizontalSiblingSpacing: CGFloat = 16.0
}

extension UIButton {

    static func bgImage() -> UIImage {
        let pxHeight = 1.0/UIScreen.mainScreen().scale
        let rect = CGRect(x: 0, y: 0, width: 3.0, height: 3.0)
        UIGraphicsBeginImageContext(rect.size)
        UIColor.lightGrayColor().set()
        CGContextFillRect(UIGraphicsGetCurrentContext(), rect)
        UIColor.whiteColor().set()
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectInset(rect, pxHeight, pxHeight))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img.resizableImageWithCapInsets(UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0))
    }

    class func applyAppearance() {

        appearance().setBackgroundImage(bgImage(), forState: .Normal)
        AMC_appearanceWhenContainedIn(UITableViewCell.self).setBackgroundImage(nil, forState: .Normal)
        appearance().setTitleColor(UIColor.darkTextColor(), forState: .Normal)
    }
}

extension UILabel {
    class func applyAppearance() {
    }
}

extension UINavigationItem {
    class func applyAppearance() {
        
    }
}

class Appearance {
    class func apply() {
        UIButton.applyAppearance()
        UILabel.applyAppearance()
    }
}

