@testable import AmericanChronicle

class FakeUSStatePickerPresenter: USStatePickerPresenterInterface {

    // MARK: Test stuff

    var didCallConfigureWithUserInterface: USStatePickerUserInterface?
    var didCallConfigureWithSelectedStateNames: [String]?

    // MARK: USStatePickerPresenterInterface conformance

    var wireframe: USStatePickerWireframeInterface?
    func configure(userInterface: USStatePickerUserInterface,
                   withSelectedStateNames selectedStateNames: [String]) {
        didCallConfigureWithUserInterface = userInterface
        didCallConfigureWithSelectedStateNames = selectedStateNames
    }

    // MARK: USStatePickerUserInterfaceDelegate conformance

    func userDidTapSave(with selectedStateNames: [String]) {}
    func userDidTapCancel() {}
}
