//
//  Style.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/30/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit
import DynamicColor

struct Font {
    private static let bodyFontName = "AvenirNext-Regular"
    private static let bodyBoldFontName = "AvenirNext-Medium"
    private static let largeFontSize = CGFloat(20.0)
    private static let mediumFontSize = CGFloat(14.0)
    private static let smallFontSize = CGFloat(12.0)
    static let largeBody = UIFont(name: bodyFontName, size: largeFontSize)
    static let largeBodyBold = UIFont(name: bodyBoldFontName, size: largeFontSize)
    static let mediumBody = UIFont(name: bodyFontName, size: mediumFontSize)
    static let mediumBodyBold = UIFont(name: bodyBoldFontName, size: mediumFontSize)
    static let smallBody = UIFont(name: bodyFontName, size: smallFontSize)
}

struct Colors {
//    https://dribbble.com/colors/3E3F42
    static let darkGray = UIColor(hex: 0x3e3f42)
//    https://dribbble.com/colors/2BA9E1
    static let lightBlueBright = UIColor(hex: 0x2ba9e1)
//    https://dribbble.com/colors/2BA9E1
    static let lightBlueBrightTransparent = lightBlueBright.colorWithAlphaComponent(0.2)
//    https://dribbble.com/colors/A2A2A4
    static let lightGray = UIColor(hex: 0xe4e4e4)
//    https://dribbble.com/colors/5484A0
    static let darkBlue = UIColor(hex: 0x5484a0)
//    https://dribbble.com/colors/D5D8DC
    static let offWhite = UIColor(hex: 0xd5d8dc)
//    https://dribbble.com/colors/ABC5D7
    static let lightBlueDull = UIColor(hex: 0xabc5d7)
//    https://dribbble.com/colors/98AEC0
    static let blueGray = UIColor(hex: 0x98aec0)

    static let lightBackground = UIColor(hex: 0xf4f4f4)
}

struct Measurements {
    static let verticalMargin: CGFloat = 16.0
    static let horizontalMargin: CGFloat = 16.0
    static let buttonHeight: CGFloat = 48.0

    static let verticalSiblingSpacing: CGFloat = 8.0
    static let horizontalSiblingSpacing: CGFloat = 8.0

    static let leftBarButtonItemTitleAdjustment = UIOffset(horizontal: 4.0, vertical: 0)
    static let rightBarButtonItemTitleAdjustment =  UIOffset(horizontal: -4.0, vertical: 0)
}

extension UIButton {

    class func normalBgImage() -> UIImage {
        return UIImage.imageWithFillColor(UIColor.whiteColor(), borderColor: UIColor.whiteColor())
    }

    class func highlightedBgImage() -> UIImage {
        return UIImage.imageWithFillColor(Colors.lightBlueBright, borderColor: Colors.lightBlueBright)
    }

    class func applyAppearance() {
        appearance().setTitleColor(Colors.darkGray, forState: .Normal)
        appearance().setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
    }
}

extension UILabel {
    class func applyAppearance() {
    }
}

extension UINavigationBar {
    class func applyAppearance() {
        appearance().setBackgroundImage(UIImage.imageWithFillColor(UIColor.whiteColor(), borderColor: UIColor.whiteColor()), forBarPosition: .Any, barMetrics: .Default)

        var attributes: [String: AnyObject] = [:]
        attributes[NSForegroundColorAttributeName] = Colors.darkGray
        attributes[NSFontAttributeName] = Font.largeBodyBold
        appearance().titleTextAttributes = attributes

    }
}

extension UIBarButtonItem {
    class func applyAppearance() {
        var attributes: [String: AnyObject] = [:]
        attributes[NSForegroundColorAttributeName] = Colors.lightBlueBright
        attributes[NSFontAttributeName] = Font.largeBody
        appearance().setTitleTextAttributes(attributes, forState: .Normal)

        attributes[NSForegroundColorAttributeName] = Colors.lightBlueDull
        attributes[NSFontAttributeName] = Font.largeBody
        appearance().setTitleTextAttributes(attributes, forState: .Highlighted)

        attributes[NSForegroundColorAttributeName] = Colors.lightBlueBright
        attributes[NSFontAttributeName] = Font.largeBody
        appearance().setTitleTextAttributes(attributes, forState: .Selected)
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

