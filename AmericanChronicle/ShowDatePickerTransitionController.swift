final class ShowDatePickerTransitionController: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.1

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let toVC = transitionContext.viewController(forKey: .to) as? DatePickerViewController else { return }

        transitionContext.containerView.addSubview(toVC.view)
        toVC.view.layoutIfNeeded()
        toVC.view.backgroundColor = UIColor(white: 0, alpha: 0)
        toVC.showKeyboard()
        UIView.animate(withDuration: duration, animations: {
            toVC.view.layoutIfNeeded()
            toVC.view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }

    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
}
