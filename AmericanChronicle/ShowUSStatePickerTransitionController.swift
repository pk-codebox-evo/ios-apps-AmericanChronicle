final class ShowUSStatePickerTransitionController: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.1

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        let fromNVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? UINavigationController

        if let _ = fromNVC?.topViewController as? SearchViewController {
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
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
}
