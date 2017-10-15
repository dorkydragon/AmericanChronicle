// MARK: -
// MARK: DatePickerUserInterface

protocol DatePickerUserInterface {
    weak var delegate: DatePickerUserInterfaceDelegate? { get set }
    var selectedDayMonthYear: DayMonthYear { get set }
    var title: String? { get set }
}

// MARK: -
// MARK: DatePickerUserInterfaceDelegate

protocol DatePickerUserInterfaceDelegate: class {
    func userDidSave(with dayMonthYear: DayMonthYear)
    func userDidCancel()
}

// MARK: -
// MARK: DatePickerViewController

final class DatePickerViewController: UIViewController, DatePickerUserInterface, DateTextFieldDelegate {

    // MARK: Properties

    var backdropAlpha: CGFloat {
        get { return backdropView.alpha }
        set { backdropView.alpha = newValue }
    }

    func showKeyboard() {
        foregroundPanel.snp.remakeConstraints { make in
            make.bottom.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(360)
        }
    }

    func hideKeyboard() {
        foregroundPanel.snp.remakeConstraints { make in
            make.bottom.equalTo(360)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(360)
        }
    }

    fileprivate let backdropView: UIView = {
        let v = UIView()
        return v
    }()
    fileprivate let foregroundPanel: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    fileprivate let earliestPossibleDayMonthYear: DayMonthYear
    fileprivate let latestPossibleDayMonthYear: DayMonthYear
    fileprivate let dateField = DateTextField()
    fileprivate let navigationBar = UINavigationBar()

    fileprivate var pagedKeyboard: PagedKeyboard?
    fileprivate let monthKeyboard = MonthKeyboard()
    fileprivate let dayKeyboard = DayKeyboard()
    fileprivate let yearPicker = ByDecadeYearPicker()

    // MARK: Init methods

    init(earliestPossibleDayMonthYear: DayMonthYear = Search.earliestPossibleDayMonthYear,
         latestPossibleDayMonthYear: DayMonthYear = Search.latestPossibleDayMonthYear) {
        self.earliestPossibleDayMonthYear = earliestPossibleDayMonthYear
        self.latestPossibleDayMonthYear = latestPossibleDayMonthYear
        selectedDayMonthYear = earliestPossibleDayMonthYear

        super.init(nibName: nil, bundle: nil)

        navigationItem.setLeftButtonTitle(NSLocalizedString("Cancel", comment: "Cancel input"),
                                          target: self,
                                          action: #selector(didTapCancelButton(_:)))
        navigationItem.setRightButtonTitle(NSLocalizedString("Save", comment: "Save input"),
                                           target: self,
                                           action: #selector(didTapSaveButton(_:)))
    }

    func monthValueChanged(_ value: Int) {
        selectedDayMonthYear = selectedDayMonthYear.copyWithMonth(value)
        dateField.selectedDayMonthYear = selectedDayMonthYear
        updateKeyboards()
    }

    func dayValueChanged(_ value: String) {
        selectedDayMonthYear = selectedDayMonthYear.copyWithDay(Int(value) ?? 0)
        dateField.selectedDayMonthYear = selectedDayMonthYear
        updateKeyboards()
    }

    func yearValueChanged(_ value: Int) {
        selectedDayMonthYear = selectedDayMonthYear.copyWithYear(value)
        dateField.selectedDayMonthYear = selectedDayMonthYear
        updateKeyboards()
    }

    func updateKeyboards() {
        monthKeyboard.selectedMonth = selectedDayMonthYear.month
        dayKeyboard.selectedDayMonthYear = selectedDayMonthYear
        yearPicker.selectedYear = selectedDayMonthYear.year
    }

    @available(*, unavailable)
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName:bundle) not supported. Use designated initializer instead")
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported. Use designated initializer instead")
    }

    @available(*, unavailable)
    init() {
        fatalError("init not supported. Use designated initializer instead")
    }

    // MARK: Internal methods

    @objc func didTapSaveButton(_ sender: UIBarButtonItem) {
        delegate?.userDidSave(with: selectedDayMonthYear)
    }

    @objc func didTapCancelButton(_ sender: UIBarButtonItem) {
        delegate?.userDidCancel()
    }

    @objc func didRecognizeTap(_ sender: UITapGestureRecognizer) {
        delegate?.userDidCancel()
    }

    // MARK: DatePickerUserInterface conformance

    weak var delegate: DatePickerUserInterfaceDelegate?
    var selectedDayMonthYear: DayMonthYear

    // MARK: DateTextFieldDelegate conformance

    func selectedSegmentDidChange(to segment: DateTextFieldSegment) {
        let activePage: UIView
        switch segment {
        case .day:
            activePage = dayKeyboard
        case .month:
            activePage = monthKeyboard
        case .year:
            activePage = yearPicker
        }
        self.pagedKeyboard?.show(page: activePage, animated: true)
    }

    // MARK: UIViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapAction = #selector(didRecognizeTap(_:))
        let tap = UITapGestureRecognizer(target: self, action: tapAction)
        backdropView.addGestureRecognizer(tap)
        view.addSubview(backdropView)
        backdropView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }

        view.addSubview(foregroundPanel)
        foregroundPanel.snp.makeConstraints { make in
            make.bottom.equalTo(360)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(360)
        }

        foregroundPanel.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
        navigationBar.pushItem(navigationItem, animated: false)

        dateField.delegate = self
        dateField.selectedDayMonthYear = selectedDayMonthYear
        foregroundPanel.addSubview(dateField)
        dateField.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(20.0)
            make.leading.equalTo(Dimension.horizontalMargin)
            make.trailing.equalTo(-Dimension.horizontalMargin)
            make.height.equalTo(66)
        }

        let keyboard = PagedKeyboard(pages: [monthKeyboard, dayKeyboard, yearPicker])
        foregroundPanel.addSubview(keyboard)
        pagedKeyboard = keyboard
        pagedKeyboard?.snp.makeConstraints { make in
            make.top.equalTo(dateField.snp.bottom)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(0)
        }

        monthKeyboard.autoresizingMask = .flexibleHeight
        monthKeyboard.selectedMonth = selectedDayMonthYear.month
        monthKeyboard.monthTapHandler = monthValueChanged

        dayKeyboard.autoresizingMask = .flexibleHeight
        dayKeyboard.selectedDayMonthYear = selectedDayMonthYear
        dayKeyboard.dayTapHandler = dayValueChanged

        yearPicker.earliestYear = Search.earliestPossibleDayMonthYear.year
        yearPicker.latestYear = Search.latestPossibleDayMonthYear.year
        yearPicker.autoresizingMask = .flexibleHeight
        yearPicker.selectedYear = selectedDayMonthYear.year
        yearPicker.yearTapHandler = yearValueChanged
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = dateField.becomeFirstResponder()
    }
}
