import SnapKit

final class MonthKeyboard: UIView {

    var monthTapHandler: ((Int) -> Void)?
    var selectedMonth: Int? { // 1-based (like the month in NSDateComponent)
        didSet {
            for (idx, button) in allMonthButtons.enumerated() {
                if let selectedMonth = selectedMonth {
                    button.isSelected = (idx == (selectedMonth - 1))
                } else {
                    button.isSelected = false
                }
            }
        }
    }

    fileprivate var allMonthButtons: [UIButton] = []

    func commonInit() {

        backgroundColor = UIColor.white

        for monthSymbol in DayMonthYear.allMonthSymbols() {
            let button: UIButton = MonthKeyboard.newButtonWithTitle(monthSymbol)
            button.addTarget(self,
                             action: #selector(didTapButton(_:)),
                             for: .touchUpInside)
            allMonthButtons.append(button)
        }
        var buttonsToAdd = allMonthButtons // copy
        var prevRow: UIButton?
        while !buttonsToAdd.isEmpty {
            var row: [UIButton] = []
            while let buttonToAdd = buttonsToAdd.first, row.count < 4 {
                row.append(buttonToAdd)
                buttonsToAdd.removeFirst()
            }
            prevRow = addRowWithButtons(row, prevRow: prevRow)
        }
        prevRow?.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-4.0)
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

    @objc func didTapButton(_ button: UIButton) {
        if let index = allMonthButtons.index(of: button) {
            monthTapHandler?(index + 1)
        }
    }

    class func newButtonWithTitle(_ title: String) -> UIButton {

        let selectedBgColor = AMCColor.brightBlue
        let normalBgColor = UIColor.white

        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = AMCFont.largeRegular
        button.layer.shadowColor = AMCColor.darkGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 0.5
        button.layer.shadowOpacity = 0.4

        button.setTitleColor(AMCColor.darkGray, for: .normal)
        button.setTitleColor(UIColor.white, for: .highlighted)
        button.setTitleColor(UIColor.white, for: .selected)
        if title == "" {
            button.isEnabled = false
        }

        let normalImage = UIImage.imageWithFillColor(normalBgColor, cornerRadius: 1.0)
        let highlightedImage = UIImage.imageWithFillColor(selectedBgColor, cornerRadius: 1.0)
        button.setBackgroundImage(normalImage, for: .normal)
        button.setBackgroundImage(highlightedImage, for: .highlighted)
        button.setBackgroundImage(highlightedImage, for: .selected)

        return button
    }

    fileprivate func addRowWithButtons(_ buttons: [UIButton], prevRow: UIButton? = nil) -> UIButton? {
        var prevColumn: UIButton?
        for button in buttons {
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
                make.leading.equalTo(leading).offset(4.0)
                make.top.equalTo(top).offset(4.0)
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
            make.trailing.equalTo(self.snp.trailing).offset(-4.0)
        }
        return prevColumn
    }

}
