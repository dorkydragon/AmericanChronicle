import SnapKit

final class DayKeyboard: UIView {

    var dayTapHandler: ((String) -> Void)?
    var selectedDayMonthYear: DayMonthYear? {
        didSet { updateCalendar() }
    }

    // mark: Init methods

    func commonInit() {
        backgroundColor = UIColor.white
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    // mark: Internal methods

    func didTapButton(_ button: UIButton) {
        if let title = button.title(for: UIControlState()) {
            dayTapHandler?(title)
        }
    }

    // mark: Private methods

    fileprivate func updateCalendar() {
        subviews.forEach { $0.removeFromSuperview() }

        guard let selectedDayMonthYear = selectedDayMonthYear else { return }
        Reporter.sharedInstance.logMessage("selectedDayMonthYear: %@",
                                           arguments: [selectedDayMonthYear.description])
        guard let rangeOfDaysThisMonth = selectedDayMonthYear.rangeOfDaysInMonth() else { return }
        var weeks: [[Int?]] = []
        for day in (1...rangeOfDaysThisMonth.length) {
            let dayMonthYear = selectedDayMonthYear.copyWithDay(day)
            guard let weekday = dayMonthYear.weekday else { continue }
            guard let weeknumber = dayMonthYear.weekOfMonth else { continue }
            let zeroBasedWeekNumber = weeknumber - 1
            if weeks.count == zeroBasedWeekNumber {
                weeks.append([Int?](repeating: nil, count: 7))
            }
            weeks[zeroBasedWeekNumber][(weekday - 1)] = day
        }
        var prevRow: UIButton?
        for week in weeks {
            let dayStrings = week.map { ($0 != nil) ? "\($0!)" : "" }
            prevRow = addRowWithTitles(dayStrings, prevRow: prevRow)

        }
        prevRow?.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-1.0)
        }

        for subview in subviews {
            if let button = subview as? UIButton,
                let title = button.title(for: UIControlState()),
                let day = Int(title) {
                button.isSelected = (day == selectedDayMonthYear.day)
            }
        }
    }

    fileprivate func addRowWithTitles(_ titles: [String], prevRow: UIButton? = nil) -> UIButton? {
        let selectedBgColor = Colors.lightBlueBright
        let normalImage = UIImage.imageWithFillColor(UIColor.white, cornerRadius: 1.0)
        let highlightedImage = UIImage.imageWithFillColor(selectedBgColor, cornerRadius: 1.0)

        var prevColumn: UIButton? = nil
        for title in titles {
            let button = UIButton()
            button.setTitle(title, for: UIControlState())
            button.titleLabel?.font = Fonts.largeRegular
            button.isEnabled = (title != "")
            button.layer.shadowColor = Colors.darkGray.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 0)
            button.layer.shadowRadius = 0.5
            button.layer.shadowOpacity = 0.4

            button.setBackgroundImage(normalImage, for: UIControlState())
            button.setBackgroundImage(highlightedImage, for: .selected)
            button.setBackgroundImage(highlightedImage, for: .highlighted)

            button.setTitleColor(Colors.blueGray, for: .normal)
            button.setTitleColor(UIColor.white, for: .highlighted)
            button.setTitleColor(UIColor.white, for: .selected)

            button.addTarget(self,
                             action: #selector(didTapButton(_:)),
                             for: .touchUpInside)
            addSubview(button)

            let leading: ConstraintItem
            if let prevColumn = prevColumn {
                leading = prevColumn.snp.trailing
            } else {
                leading = self.snp.leading
            }
            let top: ConstraintItem
            if let prevRow = prevRow {
                top = prevRow.snp.bottom
            } else {
                top = self.snp.top
            }
            button.snp.makeConstraints { make in
                make.leading.equalTo(leading).offset(2.0)
                make.top.equalTo(top).offset(2.0)
                if let width = prevColumn?.snp.width {
                    make.width.equalTo(width)
                }
                if let height = prevRow?.snp.height {
                    make.height.equalTo(height)
                } else if let height = prevColumn?.snp.height {
                    make.height.equalTo(height)
                }
            }
            prevColumn = button
        }

        prevColumn?.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).offset(-2.0)
        }
        return prevColumn
    }
}
