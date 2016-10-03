import DynamicColor

struct Fonts {
    fileprivate static let bodyFontName = "AvenirNext-Regular"
    fileprivate static let bodyBoldFontName = "AvenirNext-Medium"
    fileprivate static let largeFontSize = CGFloat(20.0)
    fileprivate static let mediumFontSize = CGFloat(16.0)
    fileprivate static let smallFontSize = CGFloat(14.0)
    fileprivate static let verySmallFontSize = CGFloat(12.0)

    static let largeRegular = UIFont(name: bodyFontName, size: largeFontSize)
    static let largeBold = UIFont(name: bodyBoldFontName, size: largeFontSize)
    static let mediumRegular = UIFont(name: bodyFontName, size: mediumFontSize)
    static let mediumBold = UIFont(name: bodyBoldFontName, size: mediumFontSize)
    static let smallRegular = UIFont(name: bodyFontName, size: smallFontSize)
    static let smallBold = UIFont(name: bodyBoldFontName, size: smallFontSize)
    static let verySmallRegular = UIFont(name: bodyFontName, size: verySmallFontSize)
    static let verySmallBold = UIFont(name: bodyBoldFontName, size: verySmallFontSize)
}

struct Colors {
    static let darkGray = UIColor(hex: 0x3e3f42)
    static let lightBlueBright = UIColor(hex: 0x2ba9e1)
    static let lightBlueBrightTransparent = lightBlueBright.withAlphaComponent(0.2)
    static let lightGray = UIColor(hex: 0xe4e4e4)
    static let darkBlue = UIColor(hex: 0x5484a0)
    static let offWhite = UIColor(hex: 0xd5d8dc)
    static let lightBlueDull = UIColor(hex: 0xabc5d7)
    static let blueGray = UIColor(hex: 0x98aec0)
    static let lightBackground = UIColor(hex: 0xf4f4f4)
}

struct Measurements {
    static let verticalMargin: CGFloat = 8.0
    static let horizontalMargin: CGFloat = 12.0
    static let buttonHeight: CGFloat = 50.0
    static let verticalSiblingSpacing: CGFloat = 6.0
    static let horizontalSiblingSpacing: CGFloat = 4.0
}

extension UINavigationBar {
    class func applyAppearance() {
        let img = UIImage.imageWithFillColor(UIColor.white)
        appearance().setBackgroundImage(img, for: .any, barMetrics: .default)
        var attributes: [String: AnyObject] = [:]
        attributes[NSForegroundColorAttributeName] = Colors.darkGray
        attributes[NSFontAttributeName] = Fonts.largeBold
        appearance().titleTextAttributes = attributes

    }
}

extension UIBarButtonItem {
    class func applyAppearance() {
        var attributes: [String: AnyObject] = [:]
        attributes[NSForegroundColorAttributeName] = Colors.lightBlueBright
        attributes[NSFontAttributeName] = Fonts.mediumRegular
        appearance().setTitleTextAttributes(attributes, for: UIControlState())

        attributes[NSForegroundColorAttributeName] = Colors.lightBlueDull
        attributes[NSFontAttributeName] = Fonts.mediumRegular
        appearance().setTitleTextAttributes(attributes, for: .highlighted)
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
