final class TitleValueButton: UIControl {

    // mark: Properties

    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    var value: String? {
        get { return valueLabel.text }
        set { valueLabel.text = newValue }
    }

    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = AMCColor.darkGray
        label.highlightedTextColor = UIColor.white
        label.textAlignment = .center
        label.font = Fonts.verySmallRegular
        return label
    }()
    fileprivate let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = AMCColor.lightBlueBright
        label.highlightedTextColor = UIColor.white
        label.font = Fonts.mediumRegular
        label.textAlignment = .center
        return label
    }()
    fileprivate let button: UIButton = {
        let b = UIButton()
        b.setBackgroundImage(UIImage.imageWithFillColor(UIColor.white, cornerRadius: 1.0), for: UIControlState())
        b.setBackgroundImage(UIImage.imageWithFillColor(AMCColor.lightBlueBright, cornerRadius: 1.0), for: .highlighted)
        return b
    }()

    // mark: Init methods

    init(title: String, initialValue: String = "--") {
        super.init(frame: .zero)

        layer.shadowColor = AMCColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 0.5
        layer.shadowOpacity = 0.4

        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.addObserver(self, forKeyPath: "highlighted", options: NSKeyValueObservingOptions.initial, context: nil)
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }

        titleLabel.text = title
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(5)
            make.leading.equalTo(8)
            make.trailing.equalTo(-8)
        }

        valueLabel.text = initialValue
        addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(2)
            make.leading.equalTo(8)
            make.trailing.equalTo(-8)
        }
    }

    @available(*, unavailable)
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @available(*, unavailable)
    init() {
        fatalError("init() has not been implemented")
    }

    // mark: Internal methods

    func didTapButton(_ sender: UIButton) {
        sendActions(for: .touchUpInside)
    }

    // mark: NSKeyValueObserving methods

    override func observeValue(forKeyPath keyPath: String?,
                                         of object: Any?,
                                                  change: [NSKeyValueChangeKey : Any]?,
                                                  context: UnsafeMutableRawPointer?) {
        isHighlighted = button.isHighlighted
    }

    // mark: UIControl overrides

    override var isHighlighted: Bool {
        didSet {
            titleLabel.isHighlighted = isHighlighted
            valueLabel.isHighlighted = isHighlighted
        }
    }

    // mark: UIView overrides

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: Measurements.buttonHeight)
    }
}
