//
//  Style.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/30/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import DynamicColor

struct Colors {
//    https://dribbble.com/colors/3E3F42
    static let darkGray = UIColor(hex: 0x3e3f42)
//    https://dribbble.com/colors/2BA9E1
    static let lightBlueBright = UIColor(hex: 0x2ba9e1)
//    https://dribbble.com/colors/A2A2A4
    static let lightGray = UIColor(hex: 0xa2a2a4)
//    https://dribbble.com/colors/5484A0
    static let darkBlue = UIColor(hex: 0x5484a0)
//    https://dribbble.com/colors/D5D8DC
    static let offWhite = UIColor(hex: 0xd5d8dc)
//    https://dribbble.com/colors/ABC5D7
    static let lightBlueDull = UIColor(hex: 0xabc5d7)
//    https://dribbble.com/colors/98AEC0
    static let blueGray = UIColor(hex: 0x98aec0)
}

struct Measurements {
    static let verticalMargin: CGFloat = 16.0
    static let horizontalMargin: CGFloat = 24.0
    static let buttonHeight: CGFloat = 48.0

    static let verticalSiblingSpacing: CGFloat = 8.0
    static let horizontalSiblingSpacing: CGFloat = 8.0
}

extension UIButton {

    class func bgImage(borderColor: UIColor, fillColor: UIColor) -> UIImage {
        let pxHeight = 1.0/UIScreen.mainScreen().scale
        let rect = CGRect(x: 0, y: 0, width: 3.0, height: 3.0)
        UIGraphicsBeginImageContext(rect.size)
        borderColor.set()
        CGContextFillRect(UIGraphicsGetCurrentContext(), rect)
        fillColor.set()
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectInset(rect, pxHeight, pxHeight))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img.resizableImageWithCapInsets(UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0))
    }

    class func normalBgImage() -> UIImage {
        return bgImage(Colors.lightBlueBright, fillColor: UIColor.whiteColor())
    }

    class func highlightedBgImage() -> UIImage {
        return bgImage(Colors.lightBlueBright, fillColor: Colors.lightBlueBright)
    }

    class func applyAppearance() {
        appearance().setBackgroundImage(normalBgImage(), forState: .Normal)
        appearance().setBackgroundImage(highlightedBgImage(), forState: .Highlighted)
        AMC_appearanceWhenContainedIn(UITableViewCell.self).setBackgroundImage(nil, forState: .Normal)
        AMC_appearanceWhenContainedIn(UITextField.self).setBackgroundImage(nil, forState: .Normal)
        appearance().setTitleColor(Colors.darkGray, forState: .Normal)
        appearance().setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
    }
}

extension UILabel {
    class func applyAppearance() {
    }
}

extension UINavigationBar {
    class func bgImage() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 3.0, height: 3.0)
        UIGraphicsBeginImageContext(rect.size)
        UIColor.whiteColor().set()
        CGContextFillRect(UIGraphicsGetCurrentContext(), rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img.resizableImageWithCapInsets(UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0))
    }
    class func applyAppearance() {
        appearance().setBackgroundImage(bgImage(), forBarPosition: .Any, barMetrics: .Default)
    }
}

extension UIBarButtonItem {
    class func applyAppearance() {
        var attributes: [String: AnyObject] = [:]
        attributes[NSForegroundColorAttributeName] = Colors.lightBlueBright
        appearance().setTitleTextAttributes(attributes, forState: .Normal)
    }
}

extension UIActivityIndicatorView {
    class func applyAppearance() {
        appearance().color = Colors.lightBlueBright
    }
}

class Appearance {
    class func apply() {
        UINavigationBar.applyAppearance()
        UIBarButtonItem.applyAppearance()
        UIButton.applyAppearance()
        UILabel.applyAppearance()
        UIActivityIndicatorView.applyAppearance()
    }
}

