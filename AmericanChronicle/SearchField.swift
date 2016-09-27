final class SearchField: UIView, UITextFieldDelegate {

    // mark: Properties

    var shouldBeginEditingHandler: ((Void) -> Bool)?
    var shouldChangeCharactersHandler: ((_ text: String,
                                         _ range: NSRange,
                                         _ replacementString: String) -> Bool)?
    var shouldClearHandler: ((Void) -> Bool)?
    var shouldReturnHandler: ((Void) -> Bool)?
    var placeholder: String? {
        get { return textField.placeholder }
        set { textField.placeholder = newValue }
    }
    var text: String {
        get { return textField.text! }
        set { textField.text = newValue }
    }

    fileprivate let textField: UITextField

    // Init methods

    func commonInit() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)

        textField.delegate = self

        let searchIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        searchIcon.image = UIImage(named: "apd_toolbar_search")?.withRenderingMode(.alwaysTemplate)
        searchIcon.tintColor = Colors.lightGray
        searchIcon.contentMode = .center
        textField.leftView = searchIcon
        textField.leftViewMode = .always
        textField.placeholder = "Search all Newspapers"
        textField.font = Fonts.largeBody
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.returnKeyType = .search
        textField.tintColor = Colors.lightBlueBright
        textField.textColor = Colors.darkGray
        textField.snp.makeConstraints { make in
            make.leading.equalTo(12.0)
            make.top.equalTo(10.0)
            make.trailing.equalTo(-17.0)
            make.bottom.equalTo(-10.0)
        }

        let bottomBorder = UIView()
        bottomBorder.backgroundColor = Colors.offWhite
        addSubview(bottomBorder)
        bottomBorder.snp.makeConstraints { make in
            make.bottom.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(1)
        }
    }

    required init?(coder: NSCoder) {
        textField = UITextField()
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        textField = UITextField()
        super.init(frame: frame)
        self.commonInit()
    }

    // mark: UIView overrides

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 64)
    }

    // mark: UIResponder overrides

    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }

    // mark: UITextFieldDelegate methods

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return shouldClearHandler?() ?? true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return shouldBeginEditingHandler?() ?? true
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        return shouldChangeCharactersHandler?(textField.text!,
                                              range,
                                              string) ?? true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return shouldReturnHandler?() ?? true
    }
}
