// mark: -
// mark: USStatePickerPresenterInterface protocol

protocol USStatePickerPresenterInterface: USStatePickerUserInterfaceDelegate {
    var wireframe: USStatePickerWireframeInterface? { get set }
    func configure(userInterface: USStatePickerUserInterface, withSelectedStateNames: [String])
}

// mark: -
// mark: USStatePickerPresenter class

final class USStatePickerPresenter: USStatePickerPresenterInterface {

    // mark: Properties

    weak var wireframe: USStatePickerWireframeInterface?
    fileprivate let interactor: USStatePickerInteractorInterface
    fileprivate var userInterface: USStatePickerUserInterface?

    // mark: Init methods

    init(interactor: USStatePickerInteractorInterface = USStatePickerInteractor()) {
        self.interactor = interactor
    }

    // mark: USStatePickerPresenterInterface methods

    func configure(userInterface: USStatePickerUserInterface,
                   withSelectedStateNames selectedStateNames: [String]) {
        self.userInterface = userInterface
        interactor.loadStateNames { [weak self] names, error in
            if let names = names {
                self?.userInterface?.stateNames = names
                self?.userInterface?.setSelectedStateNames(selectedStateNames)
            }
        }
    }

    // mark: USStatePickerUserInterfaceDelegate methods

    func userDidTapSave(_ selectedStateNames: [String]) {
        self.wireframe?.userDidTapSave(selectedStateNames)
    }

    func userDidTapCancel() {
        self.wireframe?.userDidTapCancel()
    }
}
