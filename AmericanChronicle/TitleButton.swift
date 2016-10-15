final class TitleButton: UIButton {

    init(title: String) {
        super.init(frame: .zero)

        layer.shadowColor = AMCColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 0.5
        layer.shadowOpacity = 0.4

        titleLabel?.font = AMCFont.mediumRegular
        setTitleColor(AMCColor.brightBlue, for: .normal)
        setTitleColor(UIColor.white, for: .highlighted)
        setBackgroundImage(UIImage.imageWithFillColor(UIColor.white), for: UIControlState())
        setBackgroundImage(UIImage.imageWithFillColor(AMCColor.brightBlue), for: .highlighted)
        setTitle(title, for: UIControlState())
    }

    override convenience init(frame: CGRect) {
        self.init(title: "")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
