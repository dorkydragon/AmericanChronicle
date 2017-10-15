import DynamicColor

extension UINavigationBar {
    class func applyAppearance() {
        let img = UIImage.imageWithFillColor(UIColor.white)
        appearance().setBackgroundImage(img, for: .any, barMetrics: .default)
        var attributes: [NSAttributedStringKey: Any] = [:]
        attributes[NSAttributedStringKey.foregroundColor] = AMCColor.darkGray
        attributes[NSAttributedStringKey.font] = AMCFont.largeBold
        appearance().titleTextAttributes = attributes

    }
}

extension UIBarButtonItem {
    class func applyAppearance() {
        var attributes: [NSAttributedStringKey: Any] = [:]
        attributes[NSAttributedStringKey.foregroundColor] = AMCColor.brightBlue
        attributes[NSAttributedStringKey.font] = AMCFont.mediumRegular
        appearance().setTitleTextAttributes(attributes, for: UIControlState())

        attributes[NSAttributedStringKey.foregroundColor] = AMCColor.robinBlue
        attributes[NSAttributedStringKey.font] = AMCFont.mediumRegular
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
