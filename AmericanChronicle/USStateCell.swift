final class USStateCell: UICollectionViewCell {
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.white
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = AMCColor.lightBlueBright
        label.textAlignment = .center
        label.font = Fonts.largeRegular
        label.frame = self.bounds
        label.highlightedTextColor = UIColor.white
        contentView.addSubview(label)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
