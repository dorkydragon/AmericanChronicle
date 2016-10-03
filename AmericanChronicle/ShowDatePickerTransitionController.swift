final class ShowDatePickerTransitionController: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.1

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        if let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
            toView.alpha = 0
            transitionContext.containerView.addSubview(toView)
            UIView.animate(withDuration: duration, animations: {
                toView.alpha = 1.0
                }, completion: { _ in
                    transitionContext.completeTransition(true)
            })
        }
    }

    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
}
