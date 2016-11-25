// MARK: -
// MARK: PageWireframeInterface protocol

protocol PageWireframeInterface: class {
    func present(from: UIViewController?, withSearchTerm: String?, remoteURL: URL, id: String)
    func dismiss()
    func showShareScreen(withImage image: UIImage?)
}

// MARK: -
// MARK: PageWireframeDelegate protocol

protocol PageWireframeDelegate: class {
    func pageWireframeDidFinish(_ wireframe: PageWireframeInterface)
}

// MARK: -
// MARK: PageWireframe class

final class PageWireframe: PageWireframeInterface {

    // MARK: Properties

    fileprivate let presenter: PagePresenterInterface
    fileprivate var presentedViewController: UIViewController?
    fileprivate weak var delegate: PageWireframeDelegate?

    init(delegate: PageWireframeDelegate, presenter: PagePresenterInterface = PagePresenter()) {
        self.delegate = delegate
        self.presenter = presenter
        presenter.wireframe = self
    }

    // MARK: PageWireframeInterface conformance

    func present(from presentingViewController: UIViewController?,
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

    func dismiss() {
        presentedViewController?.presentingViewController?.dismiss(animated: true, completion: {
            self.delegate?.pageWireframeDidFinish(self)
        })
    }

    func showShareScreen(withImage image: UIImage?) {
        if let image = image {
            let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
            presentedViewController?.present(vc, animated: true, completion: nil)
        }
    }
}
