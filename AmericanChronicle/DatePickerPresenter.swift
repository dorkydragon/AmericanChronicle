// mark: -
// mark: DatePickerPresenterInterface protocol

protocol DatePickerPresenterInterface: DatePickerUserInterfaceDelegate {
    var wireframe: DatePickerWireframeInterface? { get set }
    func configureUserInterfaceForPresentation(_ userInterface: DatePickerUserInterface,
                                               withDayMonthYear: DayMonthYear?,
                                               title: String?)
}

// mark: -
// mark: DatePickerPresenter class

final class DatePickerPresenter: DatePickerPresenterInterface {

    // mark: Properties

    weak var wireframe: DatePickerWireframeInterface?

    fileprivate let interactor: DatePickerInteractorInterface
    fileprivate var userInterface: DatePickerUserInterface?

    // mark: Init methods

    init(interactor: DatePickerInteractorInterface = DatePickerInteractor()) {
        self.interactor = interactor
    }

    // mark: DatePickerPresenterInterface methods

    func configureUserInterfaceForPresentation(_ userInterface: DatePickerUserInterface,
                                               withDayMonthYear dayMonthYear: DayMonthYear?,
                                               title: String?) {
        self.userInterface = userInterface
        if let dayMonthYear = dayMonthYear {
            self.userInterface?.title = title
            self.userInterface?.selectedDayMonthYear = dayMonthYear
        }
    }

    // mark: DatePickerUserInterfaceDelegate methods

    func userDidSave(_ dayMonthYear: DayMonthYear) {
        wireframe?.userDidTapSave(dayMonthYear)
    }

    func userDidCancel() {
        wireframe?.userDidTapCancel()
    }
}
