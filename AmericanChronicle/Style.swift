//
//  Style.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/30/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

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

