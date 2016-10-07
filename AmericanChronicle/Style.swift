import DynamicColor

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
        attributes[NSFontAttributeName] = AMCFont.largeBold
        appearance().titleTextAttributes = attributes

    }
}

extension UIBarButtonItem {
    class func applyAppearance() {
        var attributes: [String: AnyObject] = [:]
        attributes[NSForegroundColorAttributeName] = AMCColor.lightBlueBright
        attributes[NSFontAttributeName] = AMCFont.mediumRegular
        appearance().setTitleTextAttributes(attributes, for: UIControlState())

        attributes[NSForegroundColorAttributeName] = AMCColor.lightBlueDull
        attributes[NSFontAttributeName] = AMCFont.mediumRegular
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
