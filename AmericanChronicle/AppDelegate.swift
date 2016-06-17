@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let rootWireframe = SearchWireframe()

    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Reporter.sharedInstance.applicationDidFinishLaunching()
        KeyboardService.sharedInstance.applicationDidFinishLaunching()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        rootWireframe.beginAsRootFromWindow(window)
        window?.makeKeyAndVisible()
        Appearance.apply()
        return true
    }

    func applicationDidBecomeActive(application: UIApplication) {
        Reporter.sharedInstance.applicationDidBecomeActive()
    }
}
