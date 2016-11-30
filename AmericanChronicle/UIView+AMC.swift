extension UIView {

    // As of Xcode version 8.1 (8B62), UIView's snapshotView(afterScreenUpdates:) 
    // returns an empty white view. This alternative was ripped off from a stack 
    // overflow post (http://stackoverflow.com/a/39636687/176304).
    func snapshotView() -> UIView? {
        if let snapshotImage = snapshotImage() {
            return UIImageView(image: snapshotImage)
        } else {
            return nil
        }
    }

    private func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImage
    }
}
