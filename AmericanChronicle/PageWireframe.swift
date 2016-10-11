protocol PageWireframeInterface: class {

    func present(fromViewController presentingViewController: UIViewController?,
                 withSearchTerm searchTerm: String?,
                 remoteURL: URL,
                 id: String)
    func showShareScreen(withImage image: UIImage?)
    func dismissPageScreen()
}

// mark: -
// mark: PageWireframeDelegate protocol

protocol PageWireframeDelegate: class {
    func pageWireframeDidFinish(_ wireframe: PageWireframeInterface)
}

// mark: -
// mark: PageWireframe class

final class PageWireframe: PageWireframeInterface {

    // mark: Properties

    fileprivate let presenter: PagePresenterInterface
    fileprivate var presentedViewController: UIViewController?
    fileprivate weak var delegate: PageWireframeDelegate?

    init(delegate: PageWireframeDelegate, presenter: PagePresenterInterface = PagePresenter()) {
        self.delegate = delegate
        self.presenter = presenter
        presenter.wireframe = self
    }

    // mark: PageWireframeInterface methods

    func present(fromViewController presentingViewController: UIViewController?,
                 withSearchTerm searchTerm: String?,
                 remoteURL: URL,
                 id: String) {
        let sb = UIStoryboard(name: "Page", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! PageViewController
        vc.delegate = presenter
        presenter.configure(userInterface: vc, withSearchTerm: searchTerm, remoteDownloadURL: remoteURL, id: id)
        presentingViewController?.present(vc, animated: true, completion: nil)
        presentedViewController = vc
    }

    func showShareScreen(withImage image: UIImage?) {
        if let image = image {
            let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
            presentedViewController?.present(vc, animated: true, completion: nil)
        }
    }

    func dismissPageScreen() {
        presentedViewController?.presentingViewController?.dismiss(animated: true, completion: {
            self.delegate?.pageWireframeDidFinish(self)
        })
    }
}
