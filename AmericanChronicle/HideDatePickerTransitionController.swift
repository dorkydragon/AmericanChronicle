final class HideDatePickerTransitionController: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.1

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        if let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) {
            UIView.animate(withDuration: duration, animations: {
                fromView.alpha = 0
                }, completion: { _ in
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
        }
    }

    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
}
