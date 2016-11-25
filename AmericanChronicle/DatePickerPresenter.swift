// MARK: -
// MARK: DatePickerPresenterInterface protocol

protocol DatePickerPresenterInterface: DatePickerUserInterfaceDelegate {
    var wireframe: DatePickerWireframeInterface? { get set }
    func configure(userInterface: DatePickerUserInterface,
                   withDayMonthYear dayMonthYear: DayMonthYear?,
                   title: String?)
}

// MARK: -
// MARK: DatePickerPresenter class

final class DatePickerPresenter: DatePickerPresenterInterface {

    // MARK: Properties

    fileprivate var userInterface: DatePickerUserInterface?

    // MARK: Init methods

    init() {}

    // MARK: DatePickerPresenterInterface conformance

    weak var wireframe: DatePickerWireframeInterface?

    func configure(userInterface: DatePickerUserInterface,
                   withDayMonthYear dayMonthYear: DayMonthYear?,
                   title: String?) {
        self.userInterface = userInterface
        if let dayMonthYear = dayMonthYear {
            self.userInterface?.title = title
            self.userInterface?.selectedDayMonthYear = dayMonthYear
        }
    }

    // MARK: DatePickerUserInterfaceDelegate conformance

    func userDidSave(with dayMonthYear: DayMonthYear) {
        wireframe?.dismiss(withSelectedDayMonthYear: dayMonthYear)
    }

    func userDidCancel() {
        wireframe?.dismiss(withSelectedDayMonthYear: nil)
    }
}
