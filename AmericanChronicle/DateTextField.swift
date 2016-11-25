enum DateTextFieldSegment {
    case day
    case month
    case year
}

protocol DateTextFieldDelegate: class {
    func selectedSegmentDidChange(to: DateTextFieldSegment)
}

final class DateTextField: UIView, UITextFieldDelegate {

    // MARK: Properties

    weak var delegate: DateTextFieldDelegate?
    var selectedDayMonthYear: DayMonthYear? {
        didSet {
            // components month is 1-based.
            monthField.value = selectedDayMonthYear?.monthSymbol
            dayField.value = (selectedDayMonthYear != nil) ? "\(selectedDayMonthYear!.day)" : ""
            yearField.value = (selectedDayMonthYear != nil) ? "\(selectedDayMonthYear!.year)" : ""
        }
    }

    fileprivate let monthField = RestrictedInputField(title: NSLocalizedString("Month", comment: "Month"))
    fileprivate let dayField = RestrictedInputField(title: NSLocalizedString("Day", comment: "Day of month"))
    fileprivate let yearField = RestrictedInputField(title: NSLocalizedString("Year", comment: "Year"))

    fileprivate let normalUnderline: UIImageView = {
        let view = UIImageView(image: UIImage.imageWithFillColor(AMCColor.robinBlue))
        return view
    }()

    fileprivate let highlightUnderline: UIImageView = {
        let view = UIImageView(image: UIImage.imageWithFillColor(AMCColor.brightBlue))
        return view
    }()

    // MARK: Init methods

    func commonInit() {

        monthField.didBecomeActiveHandler = { [weak self] in
            guard let monthField = self?.monthField else { return }
            self?.highlightField(monthField)
            self?.delegate?.selectedSegmentDidChange(to: .month)
        }
        addSubview(monthField)
        monthField.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.top.equalTo(0)
        }

        dayField.didBecomeActiveHandler = { [weak self] in
            guard let dayField = self?.dayField else { return }
            self?.highlightField(dayField)
            self?.delegate?.selectedSegmentDidChange(to: .day)
        }
        addSubview(dayField)
        dayField.snp.makeConstraints { make in
            make.leading.equalTo(monthField.snp.trailing).offset(Dimension.horizontalSiblingSpacing)
            make.top.equalTo(0)
            make.width.equalTo(monthField.snp.width)
        }

        yearField.didBecomeActiveHandler = { [weak self] in
            guard let yearField = self?.yearField else { return }
            self?.highlightField(yearField)
            self?.delegate?.selectedSegmentDidChange(to: .year)
        }
        addSubview(yearField)
        yearField.snp.makeConstraints { make in
            make.leading.equalTo(dayField.snp.trailing).offset(Dimension.horizontalSiblingSpacing)
            make.top.equalTo(0)
            make.width.equalTo(dayField.snp.width)
            make.trailing.equalTo(0)
        }

        addSubview(normalUnderline)
        normalUnderline.snp.makeConstraints { make in
            make.top.equalTo(monthField.snp.bottom)
            make.leading.equalTo(monthField.snp.leading)
            make.trailing.equalTo(yearField.snp.trailing)
            make.height.equalTo(2.0)
        }

        addSubview(highlightUnderline)
        highlightUnderline.snp.makeConstraints { make in
            make.top.equalTo(monthField.snp.bottom)
            make.height.equalTo(2.0)
            make.leading.equalTo(monthField.snp.leading)
            make.width.equalTo(monthField.snp.width)
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

    // MARK: Private methods

    fileprivate func highlightField(_ field: RestrictedInputField) {
        highlightUnderline.snp.remakeConstraints { make in
            make.height.equalTo(2.0)
            make.top.equalTo(field.snp.bottom)
            make.leading.equalTo(field.snp.leading)
            make.width.equalTo(field.snp.width)
        }
        UIView.animate(withDuration: 0.1, animations: {
            self.layoutIfNeeded()
        })
    }

    // MARK: UIResponder overrides

    override func becomeFirstResponder() -> Bool {
        return monthField.becomeFirstResponder()
    }
}
