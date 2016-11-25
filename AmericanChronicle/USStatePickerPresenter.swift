// MARK: -
// MARK: USStatePickerPresenterInterface protocol

protocol USStatePickerPresenterInterface: USStatePickerUserInterfaceDelegate {
    var wireframe: USStatePickerWireframeInterface? { get set }
    func configure(userInterface: USStatePickerUserInterface, withSelectedStateNames: [String])
}

// MARK: -
// MARK: USStatePickerPresenter class

final class USStatePickerPresenter: USStatePickerPresenterInterface {

    // MARK: Properties

    weak var wireframe: USStatePickerWireframeInterface?
    fileprivate let interactor: USStatePickerInteractorInterface
    fileprivate var userInterface: USStatePickerUserInterface?

    // MARK: Init methods

    init(interactor: USStatePickerInteractorInterface = USStatePickerInteractor()) {
        self.interactor = interactor
    }

    // MARK: USStatePickerPresenterInterface methods

    func configure(userInterface: USStatePickerUserInterface,
                   withSelectedStateNames selectedStateNames: [String]) {
        self.userInterface = userInterface
        interactor.fetchStateNames { [weak self] names, error in
            if let names = names {
                self?.userInterface?.stateNames = names
                self?.userInterface?.setSelectedStateNames(selectedStateNames)
            }
        }
    }

    // MARK: USStatePickerUserInterfaceDelegate methods

    func userDidTapSave(with selectedStateNames: [String]) {
        wireframe?.dismiss(withSelectedStateNames: selectedStateNames)
    }

    func userDidTapCancel() {
        wireframe?.dismiss(withSelectedStateNames: nil)
    }
}
