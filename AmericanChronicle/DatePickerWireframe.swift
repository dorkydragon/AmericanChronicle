// mark: -
// mark: DatePickerWireframeInterface class

protocol DatePickerWireframeInterface: class {
    func presentFromViewController(_ presentingViewController: UIViewController?,
                                   withDayMonthYear dayMonthYear: DayMonthYear?,
                                   title: String?)
    func userDidTapSave(_ dayMonthYear: DayMonthYear)
    func userDidTapCancel()
}

// mark: -
// mark: DatePickerWireframeDelegate protocol

protocol DatePickerWireframeDelegate: class {
    func datePickerWireframe(_ wireframe: DatePickerWireframe, didSaveWithDayMonthYear: DayMonthYear)
    func datePickerWireframeDidFinish(_ wireframe: DatePickerWireframe)
}

// mark: -
// mark: DatePickerWireframe class

final class DatePickerWireframe: NSObject, DatePickerWireframeInterface, UIViewControllerTransitioningDelegate {

    // mark: Properties

    fileprivate let presenter: DatePickerPresenterInterface
    fileprivate var presentedViewController: UIViewController?
    fileprivate weak var delegate: DatePickerWireframeDelegate?

    // mark: Init methods

    init(delegate: DatePickerWireframeDelegate,
         presenter: DatePickerPresenterInterface = DatePickerPresenter()) {
        self.delegate = delegate
        self.presenter = presenter
        super.init()
        self.presenter.wireframe = self
    }

    // mark: DatePickerWireframeInterface methods

    func presentFromViewController(_ presentingViewController: UIViewController?,
                                   withDayMonthYear dayMonthYear: DayMonthYear?,
                                   title: String?) {
        let vc = DatePickerViewController()
        vc.delegate = presenter
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        presenter.configureUserInterfaceForPresentation(vc, withDayMonthYear: dayMonthYear, title: title)
        presentingViewController?.present(vc, animated: true, completion: nil)
        presentedViewController = vc
    }

    func userDidTapSave(_ dayMonthYear: DayMonthYear) {
        delegate?.datePickerWireframe(self, didSaveWithDayMonthYear: dayMonthYear)
        presentedViewController?.dismiss(animated: true, completion: {
            self.delegate?.datePickerWireframeDidFinish(self)
        })
    }

    func userDidTapCancel() {
        presentedViewController?.dismiss(animated: true, completion: {
            self.delegate?.datePickerWireframeDidFinish(self)
        })
    }

    // mark: UIViewControllerTransitioningDelegate methods

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ShowDatePickerTransitionController()
    }

    func animationController(
        forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HideDatePickerTransitionController()
    }
}
