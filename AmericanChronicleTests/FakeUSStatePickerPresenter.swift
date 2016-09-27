@testable import AmericanChronicle

class FakeUSStatePickerPresenter: USStatePickerPresenterInterface {
    var wireframe: USStatePickerWireframeInterface?

    var didCallConfigureWithUserInterface: USStatePickerUserInterface?
    var didCallConfigureWithSelectedStateNames: [String]?
    func configureUserInterfaceForPresentation(_ userInterface: USStatePickerUserInterface,
                                               withSelectedStateNames selectedStateNames: [String]) {
        didCallConfigureWithUserInterface = userInterface
        didCallConfigureWithSelectedStateNames = selectedStateNames
    }

    func userDidTapSave(_ selectedStateNames: [String]) {

    }

    func userDidTapCancel() {

    }
}
