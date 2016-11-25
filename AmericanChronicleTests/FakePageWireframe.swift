@testable import AmericanChronicle

final class FakePageWireframe: PageWireframeInterface {

    // MARK: Test stuff

    var dismissPageScreen_wasCalled = false

    // MARK: PageWireframeInterface conformance

    init(delegate: PageWireframeDelegate, presenter: PagePresenterInterface = PagePresenter()) {}

    func present(from presentingViewController: UIViewController?,
                 withSearchTerm searchTerm: String?,
                 remoteURL: URL,
                 id: String) {
    }

    func showShareScreen(withImage image: UIImage?) {}

    func dismiss() {
        dismissPageScreen_wasCalled = true
    }
}
