//
//  UIImage+AMC.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 2/27/16.
//  Copyright © 2016 ryanipete. All rights reserved.
//

extension UIImage {
    class func imageWithFillColor(fillColor: UIColor, borderColor: UIColor) -> UIImage {
        let pxHeight = 1.0/UIScreen.mainScreen().nativeScale
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

    class func upArrowWithFillColor(fillColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 16, height: 4))
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(8, 0))
        bezierPath.addLineToPoint(CGPointMake(0, 3))
        bezierPath.addLineToPoint(CGPointMake(0, 4))
        bezierPath.addLineToPoint(CGPointMake(8, 1))
        bezierPath.addLineToPoint(CGPointMake(16, 4))
        bezierPath.addLineToPoint(CGPointMake(16, 3))
        bezierPath.addLineToPoint(CGPointMake(8, 0))
        fillColor.setFill()
        bezierPath.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    class func downArrowWithFillColor(fillColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 16, height: 4))
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(8, 4))
        bezierPath.addLineToPoint(CGPointMake(0, 1))
        bezierPath.addLineToPoint(CGPointMake(0, 0))
        bezierPath.addLineToPoint(CGPointMake(8, 3))
        bezierPath.addLineToPoint(CGPointMake(16, 0))
        bezierPath.addLineToPoint(CGPointMake(16, 1))
        bezierPath.addLineToPoint(CGPointMake(8, 4))
        fillColor.setFill()
        bezierPath.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    class func forwardArrowWithFillColor(fillColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 24, height: 36))
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(0, 17))
        bezierPath.addLineToPoint(CGPointMake(21, 17))
        bezierPath.addLineToPoint(CGPointMake(7, 2))
        bezierPath.addLineToPoint(CGPointMake(8, 0))
        bezierPath.addLineToPoint(CGPointMake(24, 18))
        bezierPath.addLineToPoint(CGPointMake(24, 18))
        bezierPath.addLineToPoint(CGPointMake(8, 36))
        bezierPath.addLineToPoint(CGPointMake(7, 34))
        bezierPath.addLineToPoint(CGPointMake(21, 19))
        bezierPath.addLineToPoint(CGPointMake(0, 19))
        bezierPath.addLineToPoint(CGPointMake(0, 17))
        bezierPath.closePath()
        fillColor.setFill()
        bezierPath.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    class func backArrowWithFillColor(fillColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 24, height: 36))
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(24, 17))
        bezierPath.addLineToPoint(CGPointMake(3, 17))
        bezierPath.addLineToPoint(CGPointMake(17, 2))
        bezierPath.addLineToPoint(CGPointMake(16, 0))
        bezierPath.addLineToPoint(CGPointMake(0, 18))
        bezierPath.addLineToPoint(CGPointMake(0, 18))
        bezierPath.addLineToPoint(CGPointMake(16, 36))
        bezierPath.addLineToPoint(CGPointMake(17, 34))
        bezierPath.addLineToPoint(CGPointMake(3, 19))
        bezierPath.addLineToPoint(CGPointMake(24, 19))
        bezierPath.addLineToPoint(CGPointMake(24, 17))
        bezierPath.closePath()
        fillColor.setFill()
        bezierPath.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}