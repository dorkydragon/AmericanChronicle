// mark: -
// mark: DatePickerPresenterInterface protocol

protocol DatePickerPresenterInterface: DatePickerUserInterfaceDelegate {
    var wireframe: DatePickerWireframeInterface? { get set }
    func configure(userInterface: DatePickerUserInterface,
                   withDayMonthYear dayMonthYear: DayMonthYear?,
                   title: String?)
}

// mark: -
// mark: DatePickerPresenter class

final class DatePickerPresenter: DatePickerPresenterInterface {

    // mark: Properties

    fileprivate var userInterface: DatePickerUserInterface?

    // mark: Init methods

    init() {}

    // mark: DatePickerPresenterInterface conformance

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

    // mark: DatePickerUserInterfaceDelegate conformance

    func userDidSave(_ dayMonthYear: DayMonthYear) {
        wireframe?.userDidTapSave(dayMonthYear)
    }

    func userDidCancel() {
        wireframe?.userDidTapCancel()
    }
}
