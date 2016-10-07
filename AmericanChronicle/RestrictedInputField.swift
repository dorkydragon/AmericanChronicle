final class RestrictedInputField: UIView, UITextFieldDelegate {

    var didBecomeActiveHandler: (() -> Void)?
    var value: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    override var inputView: UIView? {
        get { return textField.inputView }
        set { textField.inputView = newValue }
    }

    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AMCFont.verySmallRegular
        label.textColor = AMCColor.darkGray
        label.textAlignment = .center
        return label
    }()
    fileprivate let textField: UITextField = {
        let field = UITextField()
        field.tintColor = UIColor.clear // Hide the cursor
        field.font = AMCFont.largeRegular
        field.borderStyle = .none
        field.textColor = AMCColor.darkGray
        field.textAlignment = .center
        return field
    }()
    fileprivate let tapButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(nil, for: UIControlState())
        button.setBackgroundImage(nil, for: .highlighted)
        button.setBackgroundImage(nil, for: .selected)
        return button
    }()

    // mark: Init methods

    init(title: String) {
        super.init(frame: .zero)

        titleLabel.text = title
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(12)
            make.width.equalTo(self.snp.width)
        }

        textField.inputView = inputView
        textField.inputAccessoryView = inputAccessoryView
        textField.delegate = self
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(0)
            make.trailing.equalTo(titleLabel.snp.trailing)
        }

        tapButton.addTarget(self,
                            action: #selector(didTapButton(_:)),
                            for: .touchUpInside)
        addSubview(tapButton)
        tapButton.snp.makeConstraints { make in
            make.edges.equalTo(textField)
        }

    }

    override convenience init(frame: CGRect) {
        self.init(title: "")
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // mark: Internal methods

    func didTapButton(_ sender: UIButton) {
        textField.becomeFirstResponder()
    }

    // mark: UITextFieldDelegate methods

    @objc func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.didBecomeActiveHandler?()
        return true
    }

    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }

    override var isFirstResponder: Bool {
        return textField.isFirstResponder
    }
}
