import UIKit

// MARK: -
// MARK: class DebugManager

class DebugManager: NSObject {

    // MARK: Private static properties

    private static var menuWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.windowLevel = 1.0
        let vc = DebugViewController()
      
        vc.doneCallback = { [weak window] in
            window?.hidden = true
        }
        let nvc = UINavigationController(rootViewController: vc)
        window.rootViewController = nvc
        return window
    }()

    private static var guidesWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.windowLevel = 2.0
        window.userInteractionEnabled = false
        window.rootViewController = UIViewController()
        let guidesView = window.rootViewController!.view

        // Status bar is only 20pt, so shift up by 2pt.
        var y: CGFloat = -2.0
        var rowIdx = 0
        while y <= guidesView.bounds.size.height {
            let guide = UIView(frame: CGRect(x: 0, y: y, width: guidesView.bounds.size.width, height: 22.0))
            guide.backgroundColor = ((rowIdx % 2) == 1) ? UIColor.clearColor() : UIColor(white: 0, alpha: 0.1)
            guidesView.addSubview(guide)
            y += guide.frame.size.height
            ++rowIdx
        }
        return window
    }()

    // MARK: Internal static methods

    static func enableInWindow(window: UIWindow) {
        let gesture = UILongPressGestureRecognizer(target: self, action: "debugPressRecognized:")
        // To trigger, touch down with two fingers for at least two seconds.
        gesture.minimumPressDuration = 2.0
        gesture.numberOfTouchesRequired = 2
        window.addGestureRecognizer(gesture)
    }

    static func debugPressRecognized(sender: UITapGestureRecognizer) {
        if sender.state == .Began {
            menuWindow.hidden = false
        }
    }
}
