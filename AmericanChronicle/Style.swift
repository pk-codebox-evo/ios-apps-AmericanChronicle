import DynamicColor

struct Fonts {
    private static let bodyFontName = "AvenirNext-Regular"
    private static let bodyBoldFontName = "AvenirNext-Medium"
    private static let largeFontSize = CGFloat(20.0)
    private static let mediumFontSize = CGFloat(16.0)
    private static let smallFontSize = CGFloat(12.0)
    static let largeBody = UIFont(name: bodyFontName, size: largeFontSize)
    static let largeBodyBold = UIFont(name: bodyBoldFontName, size: largeFontSize)
    static let mediumBody = UIFont(name: bodyFontName, size: mediumFontSize)
    static let mediumBodyBold = UIFont(name: bodyBoldFontName, size: mediumFontSize)
    static let smallBody = UIFont(name: bodyFontName, size: smallFontSize)
}

struct Colors {
    static let darkGray = UIColor(hex: 0x3e3f42)
    static let lightBlueBright = UIColor(hex: 0x2ba9e1)
    static let lightBlueBrightTransparent = lightBlueBright.colorWithAlphaComponent(0.2)
    static let lightGray = UIColor(hex: 0xe4e4e4)
    static let darkBlue = UIColor(hex: 0x5484a0)
    static let offWhite = UIColor(hex: 0xd5d8dc)
    static let lightBlueDull = UIColor(hex: 0xabc5d7)
    static let blueGray = UIColor(hex: 0x98aec0)
    static let lightBackground = UIColor(hex: 0xf4f4f4)
}

struct Measurements {
    static let verticalMargin: CGFloat = 14.0
    static let horizontalMargin: CGFloat = 12.0
    static let buttonHeight: CGFloat = 50.0
    static let verticalSiblingSpacing: CGFloat = 6.0
    static let horizontalSiblingSpacing: CGFloat = 4.0
}

extension UINavigationBar {
    class func applyAppearance() {
        let img = UIImage.imageWithFillColor(UIColor.whiteColor())
        appearance().setBackgroundImage(img, forBarPosition: .Any, barMetrics: .Default)
        var attributes: [String: AnyObject] = [:]
        attributes[NSForegroundColorAttributeName] = Colors.darkGray
        attributes[NSFontAttributeName] = Fonts.largeBodyBold
        appearance().titleTextAttributes = attributes

    }
}

extension UIBarButtonItem {
    class func applyAppearance() {
        var attributes: [String: AnyObject] = [:]
        attributes[NSForegroundColorAttributeName] = Colors.lightBlueBright
        attributes[NSFontAttributeName] = Fonts.mediumBody
        appearance().setTitleTextAttributes(attributes, forState: .Normal)

        attributes[NSForegroundColorAttributeName] = Colors.lightBlueDull
        attributes[NSFontAttributeName] = Fonts.mediumBody
        appearance().setTitleTextAttributes(attributes, forState: .Highlighted)
    }
}

extension UIActivityIndicatorView {
    class func applyAppearance() {
        appearance().color = Colors.lightBlueBright
    }
}

struct Appearance {
    static func apply() {
        UINavigationBar.applyAppearance()
        UIBarButtonItem.applyAppearance()
        UIActivityIndicatorView.applyAppearance()
    }
}
