final class ShowDatePickerTransitionController: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.2

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }

        let blackBG = UIView()
        blackBG.backgroundColor = UIColor.black
        transitionContext.containerView.addSubview(blackBG)
        blackBG.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }

        guard let snapshot = fromVC.view.snapshotView() else { return }
        snapshot.tag = DatePickerTransitionConstants.snapshotTag
        transitionContext.containerView.addSubview(snapshot)

        guard let toVC = transitionContext.viewController(forKey: .to) as? DatePickerViewController else { return }

        transitionContext.containerView.addSubview(toVC.view)
        toVC.view.layoutIfNeeded()
        toVC.view.backgroundColor = UIColor(white: 0, alpha: 0)
        toVC.showKeyboard()
        UIView.animate(withDuration: duration, animations: {
            toVC.view.layoutIfNeeded()
            toVC.view.backgroundColor = UIColor(white: 0, alpha: 0.8)
            snapshot.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }

    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
}
