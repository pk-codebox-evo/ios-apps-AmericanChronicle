extension UIImage {

    class func imageWithFillColor(fillColor: UIColor,
                                  borderColor: UIColor? = nil,
                                  cornerRadius: CGFloat = 0) -> UIImage {
        let pxHeight = 1.0/UIScreen.mainScreen().nativeScale
        let buttonDimension = ((cornerRadius * 2) + 1)
        let rect = CGRect(x: 0, y: 0, width: buttonDimension, height: buttonDimension)
        UIGraphicsBeginImageContext(rect.size)

        let borderColor = borderColor ?? fillColor

        borderColor.set()
        let borderPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        borderPath.fill()

        fillColor.set()
        let fillPath = UIBezierPath(roundedRect: rect.insetBy(dx: pxHeight, dy: pxHeight),
                                    cornerRadius: cornerRadius)
        fillPath.fill()

        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img.resizableImageWithCapInsets(UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius))
    }

    class func upArrowWithFillColor(fillColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 16, height: 4))
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: 8, y: 0))
        bezierPath.addLineToPoint(CGPoint(x: 0, y: 3))
        bezierPath.addLineToPoint(CGPoint(x: 0, y: 4))
        bezierPath.addLineToPoint(CGPoint(x: 8, y: 1))
        bezierPath.addLineToPoint(CGPoint(x: 16, y: 4))
        bezierPath.addLineToPoint(CGPoint(x: 16, y: 3))
        bezierPath.addLineToPoint(CGPoint(x: 8, y: 0))
        fillColor.setFill()
        bezierPath.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    class func downArrowWithFillColor(fillColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 16, height: 4))
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: 8, y: 4))
        bezierPath.addLineToPoint(CGPoint(x: 0, y: 1))
        bezierPath.addLineToPoint(CGPoint(x: 0, y: 0))
        bezierPath.addLineToPoint(CGPoint(x: 8, y: 3))
        bezierPath.addLineToPoint(CGPoint(x: 16, y: 0))
        bezierPath.addLineToPoint(CGPoint(x: 16, y: 1))
        bezierPath.addLineToPoint(CGPoint(x: 8, y: 4))
        fillColor.setFill()
        bezierPath.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    class func forwardArrowWithFillColor(fillColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 24, height: 36))
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: 0, y: 17))
        bezierPath.addLineToPoint(CGPoint(x: 21, y: 17))
        bezierPath.addLineToPoint(CGPoint(x: 7, y: 2))
        bezierPath.addLineToPoint(CGPoint(x: 8, y: 0))
        bezierPath.addLineToPoint(CGPoint(x: 24, y: 18))
        bezierPath.addLineToPoint(CGPoint(x: 24, y: 18))
        bezierPath.addLineToPoint(CGPoint(x: 8, y: 36))
        bezierPath.addLineToPoint(CGPoint(x: 7, y: 34))
        bezierPath.addLineToPoint(CGPoint(x: 21, y: 19))
        bezierPath.addLineToPoint(CGPoint(x: 0, y: 19))
        bezierPath.addLineToPoint(CGPoint(x: 0, y: 17))
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
        bezierPath.moveToPoint(CGPoint(x: 24, y: 17))
        bezierPath.addLineToPoint(CGPoint(x: 3, y: 17))
        bezierPath.addLineToPoint(CGPoint(x: 17, y: 2))
        bezierPath.addLineToPoint(CGPoint(x: 16, y: 0))
        bezierPath.addLineToPoint(CGPoint(x: 0, y: 18))
        bezierPath.addLineToPoint(CGPoint(x: 0, y: 18))
        bezierPath.addLineToPoint(CGPoint(x: 16, y: 36))
        bezierPath.addLineToPoint(CGPoint(x: 17, y: 34))
        bezierPath.addLineToPoint(CGPoint(x: 3, y: 19))
        bezierPath.addLineToPoint(CGPoint(x: 24, y: 19))
        bezierPath.addLineToPoint(CGPoint(x: 24, y: 17))
        bezierPath.closePath()
        fillColor.setFill()
        bezierPath.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
