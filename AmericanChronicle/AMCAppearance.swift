import DynamicColor

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
        attributes[NSForegroundColorAttributeName] = AMCColor.brightBlue
        attributes[NSFontAttributeName] = AMCFont.mediumRegular
        appearance().setTitleTextAttributes(attributes, for: UIControlState())

        attributes[NSForegroundColorAttributeName] = AMCColor.robinBlue
        attributes[NSFontAttributeName] = AMCFont.mediumRegular
        appearance().setTitleTextAttributes(attributes, for: .highlighted)
    }
}

extension UIActivityIndicatorView {
    class func applyAppearance() {
        appearance().color = AMCColor.brightBlue
    }
}

struct AMCAppearance {
    static func apply() {
        UINavigationBar.applyAppearance()
        UIBarButtonItem.applyAppearance()
        UIActivityIndicatorView.applyAppearance()
    }
}
