@testable import AmericanChronicle

final class FakePageWireframe: PageWireframeInterface {
    var dismissPageScreen_wasCalled = false

    init(delegate: PageWireframeDelegate, presenter: PagePresenterInterface = PagePresenter()) {

    }

    func present(fromViewController presentingViewController: UIViewController?,
                 withSearchTerm searchTerm: String?,
                 remoteURL: URL,
                 id: String) {

    }

    func showShareScreen(withImage image: UIImage?) {

    }

    func dismissPageScreen() {
        dismissPageScreen_wasCalled = true
    }
}
