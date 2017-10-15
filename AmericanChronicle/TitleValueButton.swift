final class TitleValueButton: UIControl {

    // MARK: Properties

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
        label.font = AMCFont.verySmallRegular
        return label
    }()
    fileprivate let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = AMCColor.brightBlue
        label.highlightedTextColor = UIColor.white
        label.font = AMCFont.mediumRegular
        label.textAlignment = .center
        return label
    }()
    fileprivate let button: UIButton = {
        let b = UIButton()
        b.setBackgroundImage(UIImage.imageWithFillColor(UIColor.white, cornerRadius: 1.0), for: UIControlState())
        b.setBackgroundImage(UIImage.imageWithFillColor(AMCColor.brightBlue, cornerRadius: 1.0), for: .highlighted)
        return b
    }()

    private var observingToken: NSKeyValueObservation?

    // MARK: Init methods

    init(title: String, initialValue: String = "--") {
        super.init(frame: .zero)

        layer.shadowColor = AMCColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 0.5
        layer.shadowOpacity = 0.4

        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        observingToken = button.observe(\UIButton.highlighted) { [weak self] _, _ in
            self?.isHighlighted = (self?.button.isHighlighted ?? false)
        }
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

    // MARK: Internal methods

    @objc func didTapButton(_ sender: UIButton) {
        sendActions(for: .touchUpInside)
    }

    // MARK: UIControl overrides

    override var isHighlighted: Bool {
        didSet {
            titleLabel.isHighlighted = isHighlighted
            valueLabel.isHighlighted = isHighlighted
        }
    }

    // MARK: UIView overrides

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: Dimension.buttonHeight)
    }
}
