final class ErrorView: UIView {

    // MARK: Properties

    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }

    var message: String? {
        get {
            return messageLabel.text
        }
        set {
            messageLabel.text = newValue
        }
    }

    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    fileprivate let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    // MARK: Init methods

    func commonInit() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(Dimension.verticalMargin)
            make.leading.equalTo(Dimension.horizontalMargin)
            make.trailing.equalTo(-Dimension.horizontalMargin)
        }
        addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Dimension.horizontalMargin)
            make.leading.equalTo(Dimension.horizontalMargin)
            make.bottom.equalTo(-Dimension.verticalMargin)
            make.trailing.equalTo(-Dimension.horizontalMargin)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}
