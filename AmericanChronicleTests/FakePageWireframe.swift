@testable import AmericanChronicle

class FakePageWireframe: PageWireframeProtocol {
    var dismissPageScreen_wasCalled = false

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
