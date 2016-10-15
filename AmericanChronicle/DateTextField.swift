protocol DateTextFieldDelegate: class {
    func selectedDayMonthYearDidChange(_ selectedDayMonthYear: DayMonthYear?)
}

final class DateTextField: UIView, UITextFieldDelegate {

    // mark: Properties

    weak var delegate: DateTextFieldDelegate?
    var selectedDayMonthYear: DayMonthYear? {
        didSet {
            // components month is 1-based.
            monthKeyboard.selectedMonth = selectedDayMonthYear?.month
            monthField.value = selectedDayMonthYear?.monthSymbol

            dayKeyboard.selectedDayMonthYear = selectedDayMonthYear
            dayField.value = (selectedDayMonthYear != nil) ? "\(selectedDayMonthYear!.day)" : ""

            yearPicker.selectedYear = selectedDayMonthYear?.year
            yearField.value = (selectedDayMonthYear != nil) ? "\(selectedDayMonthYear!.year)" : ""
        }
    }

    fileprivate let pagedKeyboard: PagedKeyboard
    fileprivate let monthKeyboard = MonthKeyboard()
    fileprivate let dayKeyboard = DayKeyboard()
    fileprivate let yearPicker = ByDecadeYearPicker()

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

    // mark: Init methods

    func commonInit() {

        monthKeyboard.autoresizingMask = .flexibleHeight
        monthKeyboard.monthTapHandler = monthValueChanged

        monthField.inputView = pagedKeyboard
        monthField.didBecomeActiveHandler = { [weak self] in
            guard let monthField = self?.monthField else { return }
            self?.highlightField(monthField)
        }
        addSubview(monthField)
        monthField.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.top.equalTo(0)
        }

        dayKeyboard.autoresizingMask = .flexibleHeight
        dayKeyboard.dayTapHandler = dayValueChanged

        dayField.inputView = pagedKeyboard
        dayField.didBecomeActiveHandler = { [weak self] in
            guard let dayField = self?.dayField else { return }
            self?.highlightField(dayField)
        }
        addSubview(dayField)
        dayField.snp.makeConstraints { make in
            make.leading.equalTo(monthField.snp.trailing)
                .offset(Dimension.horizontalSiblingSpacing)
            make.top.equalTo(0)
            make.width.equalTo(monthField.snp.width)
        }

        yearPicker.earliestYear = Search.earliestPossibleDayMonthYear.year
        yearPicker.latestYear = Search.latestPossibleDayMonthYear.year
        yearPicker.autoresizingMask = .flexibleHeight
        yearPicker.yearTapHandler = yearValueChanged

        yearField.inputView = pagedKeyboard
        yearField.didBecomeActiveHandler = { [weak self] in
            guard let yearField = self?.yearField else { return }
            self?.highlightField(yearField)
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
        pagedKeyboard = PagedKeyboard(pages: [monthKeyboard, dayKeyboard, yearPicker])
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        pagedKeyboard = PagedKeyboard(pages: [monthKeyboard, dayKeyboard, yearPicker])
        super.init(coder: coder)
        commonInit()
    }

    // mark: Internal methods

    func monthValueChanged(_ value: Int) {
        selectedDayMonthYear = selectedDayMonthYear?.copyWithMonth(value)
        delegate?.selectedDayMonthYearDidChange(selectedDayMonthYear)
    }

    func dayValueChanged(_ value: String) {
        selectedDayMonthYear = selectedDayMonthYear?.copyWithDay(Int(value) ?? 0)
        delegate?.selectedDayMonthYearDidChange(selectedDayMonthYear)
    }

    func yearValueChanged(_ value: String) {
        selectedDayMonthYear = selectedDayMonthYear?.copyWithYear(Int(value) ?? 0)
        delegate?.selectedDayMonthYearDidChange(selectedDayMonthYear)
    }

    // mark: Private methods

    fileprivate func highlightField(_ field: RestrictedInputField) {
        highlightUnderline.snp.remakeConstraints { make in
            make.height.equalTo(2.0)
            make.top.equalTo(field.snp.bottom)
            make.leading.equalTo(field.snp.leading)
            make.width.equalTo(field.snp.width)
        }
        let pageIndex = [monthField, dayField, yearField].index(of: field)!
        UIView.animate(withDuration: 0.1, animations: {
            self.layoutIfNeeded()
            self.pagedKeyboard.setVisiblePage(pageIndex, animated: false)
        })
    }

    // mark: UIResponder overrides

    override func becomeFirstResponder() -> Bool {
        return monthField.becomeFirstResponder()
    }
}
