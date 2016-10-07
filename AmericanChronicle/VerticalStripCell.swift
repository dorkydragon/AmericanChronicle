final class VerticalStripCell: UICollectionViewCell {

    var text: String? {
        get { return label.text }
        set { label.text = newValue }
    }

    fileprivate let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = AMCColor.darkBlue
        label.font = AMCFont.largeRegular
        return label
    }()

    func commonInit() {
        backgroundColor = UIColor.white
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.frame = bounds
        addSubview(label)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
}
