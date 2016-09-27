extension UINavigationItem {
    func setLeftButtonTitle(_ title: String, target: AnyObject?, action: Selector) {
        leftBarButtonItem = UIBarButtonItem(title: title,
                                            style: .plain,
                                            target: target,
                                            action: action)
        leftBarButtonItem?.setTitlePositionAdjustment(UIOffset(horizontal: 4.0, vertical: 0),
                                                      for: .default)
    }

    func setRightButtonTitle(_ title: String, target: AnyObject?, action: Selector) {
        rightBarButtonItem = UIBarButtonItem(title: title,
                                             style: .plain,
                                             target: target,
                                             action: action)
        rightBarButtonItem?.setTitlePositionAdjustment(UIOffset(horizontal: -4.0, vertical: 0),
                                                       for: .default)
    }
}
