final class ByDecadeYearPickerCell: UICollectionViewCell {

    // mark: Properties

    var text: String? {
        get { return label.text }
        set { label.text = newValue }
    }
    override var isHighlighted: Bool {
        didSet { updateFormat() }
    }
    override var isSelected: Bool {
        didSet { updateFormat() }
    }

    fileprivate let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Fonts.largeRegular
        label.textColor = AMCColor.darkGray
        return label
    }()
    fileprivate let insetBackgroundView: UIImageView = {
        let image = UIImage.imageWithFillColor(UIColor.white, cornerRadius: 1.0)
        return UIImageView(image: image)
    }()

    func commonInit() {

        contentView.addSubview(insetBackgroundView)
        insetBackgroundView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.edges).inset(1.0)
        }

        insetBackgroundView.layer.shadowColor = AMCColor.darkGray.cgColor
        insetBackgroundView.layer.shadowOpacity = 0.3
        insetBackgroundView.layer.shadowRadius = 0.5
        insetBackgroundView.layer.shadowOffset = .zero

        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }

        updateFormat()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    fileprivate func updateFormat() {
        if self.isHighlighted {
            insetBackgroundView.image = UIImage.imageWithFillColor(AMCColor.lightBlueBright,
                                                                   cornerRadius: 1.0)
            self.label.textColor = UIColor.white
        } else if self.isSelected {
            insetBackgroundView.image = UIImage.imageWithFillColor(AMCColor.lightBlueBright,
                                                                   cornerRadius: 1.0)
            self.label.textColor = UIColor.white
        } else {
            insetBackgroundView.image = UIImage.imageWithFillColor(UIColor.white,
                                                                   cornerRadius: 1.0)
            self.label.textColor = AMCColor.darkBlue
        }
    }
}
