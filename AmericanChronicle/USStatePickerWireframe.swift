// mark: -
// mark: USStatePickerWireframeInterface protocol

protocol USStatePickerWireframeInterface: class {
    func presentFromViewController(_ presentingViewController: UIViewController?,
                                   withSelectedStateNames: [String])
    func userDidTapSave(_ selectedItems: [String])
    func userDidTapCancel()
}

// mark: -
// mark: USStatePickerWireframeDelegate protocol

protocol USStatePickerWireframeDelegate: class {
    func usStatePickerWireframe(_ wireframe: USStatePickerWireframe,
                                didSaveFilteredUSStateNames: [String])
    func usStatePickerWireframeDidFinish(_ wireframe: USStatePickerWireframe)
}

// mark: -
// mark: USStatePickerWireframe class

final class USStatePickerWireframe: NSObject,
    USStatePickerWireframeInterface,
    UIViewControllerTransitioningDelegate {

    // mark: Properties

    fileprivate let presenter: USStatePickerPresenterInterface
    fileprivate(set) var presentedViewController: UIViewController?
    fileprivate weak var delegate: USStatePickerWireframeDelegate?

    // mark: Init methods

    init(delegate: USStatePickerWireframeDelegate,
         presenter: USStatePickerPresenterInterface = USStatePickerPresenter()) {
        self.delegate = delegate
        self.presenter = presenter

        super.init()

        self.presenter.wireframe = self
    }

    // mark: USStatePickerWireframeInterface methods

    func presentFromViewController(_ presentingViewController: UIViewController?,
                                   withSelectedStateNames selectedStateNames: [String]) {
        let vc = USStatePickerViewController()
        vc.delegate = presenter
        presenter.configureUserInterfaceForPresentation(vc, withSelectedStateNames: selectedStateNames)

        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .custom
        nvc.transitioningDelegate = self

        presentingViewController?.present(nvc, animated: true, completion: nil)

        presentedViewController = nvc

    }

    func userDidTapSave(_ selectedItems: [String]) {
        delegate?.usStatePickerWireframe(self, didSaveFilteredUSStateNames: selectedItems)
        presentedViewController?.presentingViewController?.dismiss(animated: true, completion: {
            self.delegate?.usStatePickerWireframeDidFinish(self)
        })
    }

    func userDidTapCancel() {
        presentedViewController?.presentingViewController?.dismiss(animated: true, completion: {
            self.delegate?.usStatePickerWireframeDidFinish(self)
        })
    }

    // mark: UIViewControllerTransitioningDelegate methods

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ShowUSStatePickerTransitionController()
    }

    func animationController(
        forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HideUSStatePickerTransitionController()
    }
}
