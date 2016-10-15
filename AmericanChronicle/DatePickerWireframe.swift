// mark: -
// mark: DatePickerWireframeInterface class

protocol DatePickerWireframeInterface: class {
    func present(from: UIViewController?, withDayMonthYear: DayMonthYear?, title: String?)
    func dismiss(withSelectedDayMonthYear: DayMonthYear?)
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

    // mark: DatePickerWireframeInterface conformance

    func present(from presentingViewController: UIViewController?,
                 withDayMonthYear dayMonthYear: DayMonthYear?,
                 title: String?) {
        let vc = DatePickerViewController()
        vc.delegate = presenter
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        presenter.configure(userInterface: vc, withDayMonthYear: dayMonthYear, title: title)
        presentingViewController?.present(vc, animated: true, completion: nil)
        presentedViewController = vc
    }

    func dismiss(withSelectedDayMonthYear dayMonthYear: DayMonthYear?) {
        if let dayMonthYear = dayMonthYear {
            delegate?.datePickerWireframe(self, didSaveWithDayMonthYear: dayMonthYear)
        }
        presentedViewController?.dismiss(animated: true, completion: {
            self.delegate?.datePickerWireframeDidFinish(self)
        })
    }

    // mark: UIViewControllerTransitioningDelegate conformance

    func animationController(forPresented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ShowDatePickerTransitionController()
    }

    func animationController(forDismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HideDatePickerTransitionController()
    }
}
