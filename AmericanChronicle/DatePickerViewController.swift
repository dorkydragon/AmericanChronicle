// mark: -
// mark: DatePickerUserInterface

protocol DatePickerUserInterface {
    var delegate: DatePickerUserInterfaceDelegate? { get set }
    var selectedDayMonthYear: DayMonthYear { get set }
    var title: String? { get set }
}

// mark: -
// mark: DatePickerUserInterfaceDelegate

protocol DatePickerUserInterfaceDelegate: class {
    func userDidSave(_ dayMonthYear: DayMonthYear)
    func userDidCancel()
}

// mark: -
// mark: DatePickerViewController

final class DatePickerViewController: UIViewController, DatePickerUserInterface, DateTextFieldDelegate {

    // mark: Properties

    weak var delegate: DatePickerUserInterfaceDelegate?
    var selectedDayMonthYear: DayMonthYear

    fileprivate let foregroundPanel: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    fileprivate let earliestPossibleDayMonthYear: DayMonthYear
    fileprivate let latestPossibleDayMonthYear: DayMonthYear
    fileprivate let dateField = DateTextField()
    fileprivate let navigationBar = UINavigationBar()

    // mark: Init methods

    init(earliestPossibleDayMonthYear: DayMonthYear = Search.earliestPossibleDayMonthYear,
         latestPossibleDayMonthYear: DayMonthYear = Search.latestPossibleDayMonthYear) {
        self.earliestPossibleDayMonthYear = earliestPossibleDayMonthYear
        self.latestPossibleDayMonthYear = latestPossibleDayMonthYear
        selectedDayMonthYear = earliestPossibleDayMonthYear

        super.init(nibName: nil, bundle: nil)

        navigationItem.setLeftButtonTitle("Cancel",
                                          target: self,
                                          action: #selector(didTapCancelButton(_:)))
        navigationItem.setRightButtonTitle("Save",
                                           target: self,
                                           action: #selector(didTapSaveButton(_:)))
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

    // mark: Internal methods

    func didTapSaveButton(_ sender: UIBarButtonItem) {
        delegate?.userDidSave(selectedDayMonthYear)
    }

    func didTapCancelButton(_ sender: UIBarButtonItem) {
        delegate?.userDidCancel()
    }

    func didRecognizeTap(_ sender: UITapGestureRecognizer) {
        delegate?.userDidCancel()
    }

    // mark: DateTextFieldDelegate methods

    func selectedDayMonthYearDidChange(_ dayMonthYear: DayMonthYear?) {
        if let dayMonthYear = dayMonthYear {
            selectedDayMonthYear = dayMonthYear
        }
    }

    // mark: UIViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        let tapAction = #selector(didRecognizeTap(_:))
        let tap = UITapGestureRecognizer(target: self,
                                         action: tapAction)
        view.addGestureRecognizer(tap)

        view.addSubview(foregroundPanel)
        foregroundPanel.snp.makeConstraints { make in
            make.bottom.equalTo(0)
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
            make.leading.equalTo(Measurements.horizontalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)
            make.height.equalTo(66)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = dateField.becomeFirstResponder()
    }
}
