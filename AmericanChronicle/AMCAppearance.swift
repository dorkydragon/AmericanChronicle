import DynamicColor

extension UINavigationBar {
    class func applyAppearance() {
        let img = UIImage.imageWithFillColor(UIColor.white)
        appearance().setBackgroundImage(img, for: .any, barMetrics: .default)
        var attributes: [NSAttributedString.Key: Any] = [:]
        attributes[.foregroundColor] = AMCColor.darkGray
        attributes[.font] = AMCFont.largeBold
        appearance().titleTextAttributes = attributes

    }
}

extension UIBarButtonItem {
    class func applyAppearance() {
        var attributes: [NSAttributedString.Key: Any] = [:]
        attributes[.foregroundColor] = AMCColor.brightBlue
        attributes[.font] = AMCFont.mediumRegular
        appearance().setTitleTextAttributes(attributes, for: .normal)

        attributes[.foregroundColor] = AMCColor.robinBlue
        attributes[.font] = AMCFont.mediumRegular
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
