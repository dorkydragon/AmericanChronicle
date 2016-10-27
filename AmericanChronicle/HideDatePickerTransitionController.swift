final class HideDatePickerTransitionController: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.2

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let fromVC = transitionContext.viewController(forKey: .from) as? DatePickerViewController else { return }

        let snapshot = transitionContext.containerView.viewWithTag(DatePickerTransitionConstants.snapshotTag)

        fromVC.hideKeyboard()
        UIView.animate(withDuration: duration, animations: {
            snapshot?.transform = CGAffineTransform.identity
            fromVC.view.layoutIfNeeded()
            fromVC.view.backgroundColor = UIColor(white: 0, alpha: 0)
            }, completion: { _ in
                fromVC.view.removeFromSuperview()
                transitionContext.completeTransition(true)
        })
    }

    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
}
