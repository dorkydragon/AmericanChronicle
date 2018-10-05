final class SearchTableHeaderView: UIView {

    // MARK: Properties

    var searchTerm: String? {
        get { return searchField.text }
        set { searchField.text = newValue ?? "" }
    }
    var earliestDate: String? {
        get { return earliestDateButton.value }
        set { earliestDateButton.value = newValue }
    }
    var latestDate: String? {
        get { return latestDateButton.value }
        set { latestDateButton.value = newValue }
    }
    var usStateNames: String? {
        get { return usStatesButton.value }
        set { usStatesButton.value = newValue }
    }
    var shouldChangeCharactersHandler: ((_ text: String,
                                         _ range: NSRange,
                                         _ replacementString: String) -> Bool)? {
        get { return searchField.shouldChangeCharactersHandler }
        set { searchField.shouldChangeCharactersHandler = newValue }
    }
    var shouldReturnHandler: (() -> Bool)? {
        get { return searchField.shouldReturnHandler }
        set { searchField.shouldReturnHandler = newValue }
    }
    var shouldClearHandler: (() -> Bool)? {
        get { return searchField.shouldClearHandler }
        set { searchField.shouldClearHandler = newValue }
    }
    var earliestDateButtonTapHandler: (() -> Void)?
    var latestDateButtonTapHandler: (() -> Void)?
    var usStatesButtonTapHandler: (() -> Void)?

    fileprivate let searchField = SearchField()
    fileprivate let earliestDateButton = TitleValueButton(title: NSLocalizedString("Earliest Date", comment: "Earliest Date"))
    fileprivate let latestDateButton = TitleValueButton(title: NSLocalizedString("Latest Date", comment: "Latest Date"))
    fileprivate let usStatesButton = TitleValueButton(title: NSLocalizedString("U.S. States", comment: "U.S. States"),
                                                      initialValue: NSLocalizedString("(all states)", comment: "(all states)"))
    fileprivate let bottomBorder = UIImageView(image: UIImage.imageWithFillColor(AMCColor.lightGray))

    // MARK: Init methods

    func commonInit() {

        backgroundColor = AMCColor.offWhite

        addSubview(searchField)
        searchField.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
        searchField.backgroundColor = UIColor.white

        earliestDateButton.addTarget(self,
                                     action: #selector(didTapEarliestDateButton(_:)),
                                     for: .touchUpInside)
        addSubview(earliestDateButton)
        earliestDateButton.snp.makeConstraints { make in
            make.top.equalTo(searchField.snp.bottom).offset(8.0)
            make.leading.equalTo(Dimension.horizontalMargin)
        }

        latestDateButton.addTarget(self,
                                   action: #selector(didTapLatestDateButton(_:)),
                                   for: .touchUpInside)
        addSubview(latestDateButton)
        latestDateButton.snp.makeConstraints { make in
            make.top.equalTo(searchField.snp.bottom).offset(8.0)
            make.leading.equalTo(earliestDateButton.snp.trailing)
                        .offset(Dimension.horizontalSiblingSpacing)
            make.trailing.equalTo(-Dimension.horizontalMargin)
            make.width.equalTo(earliestDateButton.snp.width)
        }

        usStatesButton.addTarget(self,
                                 action: #selector(didTapUSStatesButton(_:)),
                                 for: .touchUpInside)
        addSubview(usStatesButton)
        usStatesButton.snp.makeConstraints { make in
            make.top.equalTo(earliestDateButton.snp.bottom)
                    .offset(Dimension.verticalSiblingSpacing)
            make.bottom.equalTo(-10.0)
            make.leading.equalTo(Dimension.horizontalMargin)
            make.trailing.equalTo(-Dimension.horizontalMargin)
        }

        addSubview(bottomBorder)
        bottomBorder.snp.makeConstraints { make in
            make.bottom.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(1)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    // MARK: Internal methods

    @objc func didTapEarliestDateButton(_ sender: TitleValueButton) {
        earliestDateButtonTapHandler?()
    }

    @objc func didTapLatestDateButton(_ sender: TitleValueButton) {
        latestDateButtonTapHandler?()
    }

    @objc func didTapUSStatesButton(_ sender: TitleValueButton) {
        usStatesButtonTapHandler?()
    }

    // MARK: UIView overrides

    override var intrinsicContentSize: CGSize {
        var size = CGSize(width: UIView.noIntrinsicMetric, height: 0)
        size.height += searchField.intrinsicContentSize.height
        size.height += Dimension.verticalMargin
        size.height += earliestDateButton.intrinsicContentSize.height
        size.height += Dimension.verticalSiblingSpacing
        size.height += usStatesButton.intrinsicContentSize.height
        size.height += Dimension.verticalMargin
        return size
    }

    // MARK: UIResponder overrides

    override func resignFirstResponder() -> Bool {
        return searchField.resignFirstResponder()
    }

    override func becomeFirstResponder() -> Bool {
        return searchField.becomeFirstResponder()
    }
}
