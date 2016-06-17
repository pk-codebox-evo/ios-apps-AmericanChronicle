final class HideDatePickerTransitionController: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.1

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) {
            UIView.animateWithDuration(duration, animations: {
                fromView.alpha = 0
                }, completion: { _ in
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
        }
    }

    func transitionDuration(
        transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
}
