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
        attributes[NSForegroundColorAttributeName] = AMCColor.darkGray
        attributes[NSFontAttributeName] = Fonts.largeBold
        appearance().titleTextAttributes = attributes

    }
}

extension UIBarButtonItem {
    class func applyAppearance() {
        var attributes: [String: AnyObject] = [:]
        attributes[NSForegroundColorAttributeName] = AMCColor.lightBlueBright
        attributes[NSFontAttributeName] = Fonts.mediumRegular
        appearance().setTitleTextAttributes(attributes, for: UIControlState())

        attributes[NSForegroundColorAttributeName] = AMCColor.lightBlueDull
        attributes[NSFontAttributeName] = Fonts.mediumRegular
        appearance().setTitleTextAttributes(attributes, for: .highlighted)
    }
}

extension UIActivityIndicatorView {
    class func applyAppearance() {
        appearance().color = AMCColor.lightBlueBright
    }
}

struct Appearance {
    static func apply() {
        UINavigationBar.applyAppearance()
        UIBarButtonItem.applyAppearance()
        UIActivityIndicatorView.applyAppearance()
    }
}
