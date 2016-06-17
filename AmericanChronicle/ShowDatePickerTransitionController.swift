final class ShowDatePickerTransitionController: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.1

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        if let toView = transitionContext.viewForKey(UITransitionContextToViewKey) {
            toView.alpha = 0
            transitionContext.containerView()!.addSubview(toView)
            UIView.animateWithDuration(duration, animations: {
                toView.alpha = 1.0
                }, completion: { _ in
                    transitionContext.completeTransition(true)
            })
        }
    }

    func transitionDuration(
        transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
}
