class KeyboardService: NSObject {

    private var frameChangeHandlers: [String: (CGRect?) -> Void] = [:]

    static let sharedInstance = KeyboardService()
    private let notificationCenter: NSNotificationCenter
    private(set) var keyboardFrame: CGRect? {
        didSet {
            if keyboardFrame != oldValue {
                for (_, handler) in frameChangeHandlers {
                    handler(keyboardFrame)
                }
            }
        }
    }

    init(notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()) {
        self.notificationCenter = notificationCenter
        super.init()
    }

    func applicationDidFinishLaunching() {
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillShow(_:)),
                                       name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillHide(_:)),
                                       name: UIKeyboardWillHideNotification, object: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        let keyboardFrameEnd = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        keyboardFrame = keyboardFrameEnd?.CGRectValue()
    }

    func keyboardWillHide(notification: NSNotification) {
        keyboardFrame = nil
    }

    func addFrameChangeHandler(identifier: String, handler: (CGRect?) -> Void) {
        frameChangeHandlers[identifier] = handler
    }

    func removeFrameChangeHandler(identifier: String) {
        frameChangeHandlers[identifier] = nil
    }

    deinit {
        notificationCenter.removeObserver(self)
    }
}
