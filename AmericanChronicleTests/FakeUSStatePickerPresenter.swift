@testable import AmericanChronicle

class FakeUSStatePickerPresenter: USStatePickerPresenterInterface {

    // mark: Test stuff

    var didCallConfigureWithUserInterface: USStatePickerUserInterface?
    var didCallConfigureWithSelectedStateNames: [String]?

    // mark: USStatePickerPresenterInterface conformance

    var wireframe: USStatePickerWireframeInterface?
    func configure(userInterface: USStatePickerUserInterface,
                   withSelectedStateNames selectedStateNames: [String]) {
        didCallConfigureWithUserInterface = userInterface
        didCallConfigureWithSelectedStateNames = selectedStateNames
    }

    // mark: USStatePickerUserInterfaceDelegate conformance

    func userDidTapSave(_ selectedStateNames: [String]) {}
    func userDidTapCancel() {}
}
