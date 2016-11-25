// MARK: -
// MARK: USStatePickerWireframeInterface protocol

protocol USStatePickerWireframeInterface: class {
    func present(from: UIViewController?, withSelectedStateNames: [String])
    func dismiss(withSelectedStateNames: [String]?)
}

// MARK: -
// MARK: USStatePickerWireframeDelegate protocol

protocol USStatePickerWireframeDelegate: class {
    func usStatePickerWireframe(_ wireframe: USStatePickerWireframe,
                                didSaveFilteredUSStateNames: [String])
    func usStatePickerWireframeDidFinish(_ wireframe: USStatePickerWireframe)
}

// MARK: -
// MARK: USStatePickerWireframe class

final class USStatePickerWireframe: NSObject,
    USStatePickerWireframeInterface,
    UIViewControllerTransitioningDelegate {

    // MARK: Properties

    fileprivate let presenter: USStatePickerPresenterInterface
    fileprivate(set) var presentedViewController: UIViewController?
    fileprivate weak var delegate: USStatePickerWireframeDelegate?

    // MARK: Init methods

    init(delegate: USStatePickerWireframeDelegate,
         presenter: USStatePickerPresenterInterface = USStatePickerPresenter()) {
        self.delegate = delegate
        self.presenter = presenter

        super.init()

        self.presenter.wireframe = self
    }

    // MARK: USStatePickerWireframeInterface conformance

    func present(from presentingViewController: UIViewController?,
                 withSelectedStateNames selectedStateNames: [String]) {
        let vc = USStatePickerViewController()
        vc.delegate = presenter
        presenter.configure(userInterface: vc, withSelectedStateNames: selectedStateNames)

        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .custom
        nvc.transitioningDelegate = self

        presentingViewController?.present(nvc, animated: true, completion: nil)

        presentedViewController = nvc

    }

    func dismiss(withSelectedStateNames selectedStateNames: [String]?) {
        if let selectedItems = selectedStateNames {
            delegate?.usStatePickerWireframe(self, didSaveFilteredUSStateNames: selectedItems)
        }
        presentedViewController?.presentingViewController?.dismiss(animated: true, completion: { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.delegate?.usStatePickerWireframeDidFinish(weakSelf)
        })
    }

    // MARK: UIViewControllerTransitioningDelegate methods

    func animationController(forPresented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ShowUSStatePickerTransitionController()
    }

    func animationController(forDismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HideUSStatePickerTransitionController()
    }
}
