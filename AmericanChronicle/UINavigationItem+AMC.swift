extension UINavigationItem {
    func setLeftButtonTitle(title: String, target: AnyObject?, action: Selector) {
        leftBarButtonItem = UIBarButtonItem(title: title,
                                            style: .Plain,
                                            target: target,
                                            action: action)
        leftBarButtonItem?.setTitlePositionAdjustment(UIOffset(horizontal: 4.0, vertical: 0),
                                                      forBarMetrics: .Default)
    }

    func setRightButtonTitle(title: String, target: AnyObject?, action: Selector) {
        rightBarButtonItem = UIBarButtonItem(title: title,
                                             style: .Plain,
                                             target: target,
                                             action: action)
        rightBarButtonItem?.setTitlePositionAdjustment(UIOffset(horizontal: -4.0, vertical: 0),
                                                       forBarMetrics: .Default)
    }
}
