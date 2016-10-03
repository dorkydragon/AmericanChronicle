extension UIImage {

    class func imageWithFillColor(_ fillColor: UIColor,
                                  borderColor: UIColor? = nil,
                                  cornerRadius: CGFloat = 0) -> UIImage {
        let pxHeight = 1.0/UIScreen.main.nativeScale
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
        return img!.resizableImage(withCapInsets: UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius))
    }

    class func upArrowWithFillColor(_ fillColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 16, height: 4))
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 8, y: 0))
        bezierPath.addLine(to: CGPoint(x: 0, y: 3))
        bezierPath.addLine(to: CGPoint(x: 0, y: 4))
        bezierPath.addLine(to: CGPoint(x: 8, y: 1))
        bezierPath.addLine(to: CGPoint(x: 16, y: 4))
        bezierPath.addLine(to: CGPoint(x: 16, y: 3))
        bezierPath.addLine(to: CGPoint(x: 8, y: 0))
        fillColor.setFill()
        bezierPath.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    class func downArrowWithFillColor(_ fillColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 16, height: 4))
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 8, y: 4))
        bezierPath.addLine(to: CGPoint(x: 0, y: 1))
        bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: 8, y: 3))
        bezierPath.addLine(to: CGPoint(x: 16, y: 0))
        bezierPath.addLine(to: CGPoint(x: 16, y: 1))
        bezierPath.addLine(to: CGPoint(x: 8, y: 4))
        fillColor.setFill()
        bezierPath.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    class func forwardArrowWithFillColor(_ fillColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 24, height: 36))
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 17))
        bezierPath.addLine(to: CGPoint(x: 21, y: 17))
        bezierPath.addLine(to: CGPoint(x: 7, y: 2))
        bezierPath.addLine(to: CGPoint(x: 8, y: 0))
        bezierPath.addLine(to: CGPoint(x: 24, y: 18))
        bezierPath.addLine(to: CGPoint(x: 24, y: 18))
        bezierPath.addLine(to: CGPoint(x: 8, y: 36))
        bezierPath.addLine(to: CGPoint(x: 7, y: 34))
        bezierPath.addLine(to: CGPoint(x: 21, y: 19))
        bezierPath.addLine(to: CGPoint(x: 0, y: 19))
        bezierPath.addLine(to: CGPoint(x: 0, y: 17))
        bezierPath.close()
        fillColor.setFill()
        bezierPath.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    class func backArrowWithFillColor(_ fillColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 24, height: 36))
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 24, y: 17))
        bezierPath.addLine(to: CGPoint(x: 3, y: 17))
        bezierPath.addLine(to: CGPoint(x: 17, y: 2))
        bezierPath.addLine(to: CGPoint(x: 16, y: 0))
        bezierPath.addLine(to: CGPoint(x: 0, y: 18))
        bezierPath.addLine(to: CGPoint(x: 0, y: 18))
        bezierPath.addLine(to: CGPoint(x: 16, y: 36))
        bezierPath.addLine(to: CGPoint(x: 17, y: 34))
        bezierPath.addLine(to: CGPoint(x: 3, y: 19))
        bezierPath.addLine(to: CGPoint(x: 24, y: 19))
        bezierPath.addLine(to: CGPoint(x: 24, y: 17))
        bezierPath.close()
        fillColor.setFill()
        bezierPath.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
