import UIKit

class DebugViewController: UIViewController {

    // MARK: Properties

    var doneCallback: (() -> Void)?
    var doneButton: UIBarButtonItem!
    var realView: DebugView!

    let activeURLScheme: String = {
        let URLTypes = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleURLTypes") as? [AnyObject]
        let URLType = URLTypes?.first as? [String: AnyObject]
        let URLSchemes = URLType?["CFBundleURLSchemes"] as? [String]
        return URLSchemes?.first ?? "not found"
    }()

    let versionNumber: String = {
        let version = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
        return version ?? "not found"
    }()

    var buildNumber: String = {
        let build = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as? String
        return build ?? "not found"
    }()

    // MARK: Init methods

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported. Use designated initializer instead")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        doneButton = UIBarButtonItem.standardDismissButton(self, action: "doneButtonTapped:")
        navigationItem.leftBarButtonItem = doneButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "\(versionNumber) (\(buildNumber)) \u{00BB}", style: .Plain, target: self, action: "detailsButtonTapped:")
        navigationItem.title = activeURLScheme
    }

    override func loadView() {
        realView = DebugView(frame: CGRectZero)
        view = realView
    }

    override func viewDidLoad() {
        realView.fillWebView.addTarget(self, action: "fillWebFormButtonTapped:", forControlEvents: .TouchUpInside)
        realView.namesCreateCustomer.addTarget(self, action: "createAndSignInUser:", forControlEvents: .TouchUpInside)
        realView.pushNotificationReset.addTarget(self, action: "clearUserDefaults:", forControlEvents: .TouchUpInside)
        realView.sandboxButton.addTarget(self, action: "developerSandboxesTapped:", forControlEvents: .TouchUpInside)
        realView.namesDropDown.addTarget(self, action: "dropDownChangedValue:", forControlEvents: .ValueChanged)
        realView.applicationSystemSettings.addTarget(self, action: "goToSettings:", forControlEvents: .TouchUpInside)
        
        realView.namesCreateCustomer.enabled = false
        realView.namesDropDown.selectedIndex = 0

    }
    // MARK: Custom methods

    @IBAction func detailsButtonTapped(sender: AnyObject) {
        let vc = AppInfoViewController()
        var everything: [String: AnyObject] = [:]
        everything["Environment Variables"] = NSProcessInfo.processInfo().environment
        everything["Arguments"] = NSProcessInfo.processInfo().arguments
        everything["Info.plist"] = NSBundle.mainBundle().infoDictionary!
        everything["User Defaults"] = NSUserDefaults.standardUserDefaults().dictionaryRepresentation()
        vc.collections = ["Everything": everything]
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func doneButtonTapped(sender: AnyObject) {
        doneCallback?()
    }

    @IBAction func fillWebFormButtonTapped(sender: AnyObject) {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        let webViews: [UIWebView] = UIApplication.sharedApplication().keyWindow!.recursiveFindViews()
        if webViews.count > 0 {
            for webView in webViews {
                webView.fillAllFormFields()
            }
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            doneCallback?()
        } else {
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
    }

    @IBAction func goToSettings(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    func createAndSignInUser(sender: PrimaryCTA) {
        let selectedIdx = realView.namesDropDown.selectedIndex
        if selectedIdx == 0 { return }
        realView.namesCreateCustomer.startAnimating()
        AuthenticationService().signOut().always {
            DebugNamesHelper().createAndLoginNamesUser(DebugNamesHelper.AccountType(rawValue: String(self.realView.namesDropDown.selectedIndex))!)
                .always { self.realView.namesCreateCustomer.stopAnimating() }
                .then { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotification(.ApplicationNeedsRefresh)
                    self.doneCallback?()
                }
                .error { error in
                    ErrorPresenter().presentError(error as NSError, inViewController: self)
            }
        }
        
    }
    
    func developerSandboxesTapped(sender: SecondaryCTA) {
        let vc = DeveloperSandboxViewController()
        self.navigationController?.pushViewController(vc, animated: true)
           }
    
    @IBAction func dropDownChangedValue(sender: StitchFixDropdown) {
        sender.setExpanded(false)
        realView.namesCreateCustomer.enabled = (realView.namesDropDown.selectedIndex != 0)
    }

    @IBAction func clearUserDefaults(sender: UIButton) {
        NSUserDefaults.standardUserDefaults().pushNotificationsPermissionViewDismissed = false
        
    }
}

// MARK: -
// MARK: extension UIView

private extension UIView {
    private func recursiveFindViews<T>() -> [T] {
        var found: [T] = []
        for subview in self.subviews {
            if let subview = subview as? T {
                found.append(subview)
            } else {
                found.appendContentsOf(subview.recursiveFindViews())
            }
        }
        return found
    }
}

// MARK: -
// MARK: extension UIWebView

private extension UIWebView {

    private func fillAllFormFields() {
        fillAllSelectFields()
        fillAllInputFields()
        fillAllButtonGroups()
        scrollToBottom()
    }

    private func fillAllSelectFields() {
        var js = "var elements = document.querySelectorAll(\'select\'); "
        js += "for (var i = 0; i < elements.length; i++) { "
        js += "    elements[i].selectedIndex = 1; "
        js += "}"
        self.stringByEvaluatingJavaScriptFromString(js)
    }

    private func fillAllInputFields() {
        var js = "var elements = document.querySelectorAll(\'input\'); "
        js += "for (var i = 0; i < elements.length; i++) { "
        js += "    var element = elements[i]; "
        js += "    if (element.pattern == \'[0-9]*\') { "
        js += "        elements[i].value = Array(element.maxLength).join(\'2\'); "
        js += "    }; "
        js += "}"
        self.stringByEvaluatingJavaScriptFromString(js)
    }

    private func fillAllButtonGroups() {
        var js = "var elements = document.querySelectorAll(\'span.btn-group input\'); "
        js += "for (var nodeIdx = 0; nodeIdx < elements.length; nodeIdx++) { "
        js += "    elements[nodeIdx].checked = true; "
        js += "}"
        self.stringByEvaluatingJavaScriptFromString(js)
    }

    private func scrollToBottom() {
        // Borrowed from this StackOverflow post - http://stackoverflow.com/a/1147768
        var js = "var body = document.body,"
        js += "html = document.documentElement;"
        js += "var height = Math.max( body.scrollHeight, body.offsetHeight,"
        js += "                       html.clientHeight, html.scrollHeight, html.offsetHeight );"
        js += "window.scrollTo(0, height);"
        self.stringByEvaluatingJavaScriptFromString(js)
    }
}
