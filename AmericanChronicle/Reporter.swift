import Fabric
import Crashlytics

struct Reporter {
    static let sharedInstance = Reporter()
    func applicationDidFinishLaunching() {
        Fabric.with([Crashlytics.self])
    }

    func applicationDidBecomeActive() {
        updateReportedLocale()
    }

    func logMessage(formattedString: String, arguments: [CVarArgType] = []) {
        CLSLogv(formattedString, getVaList(arguments))
    }

    private func updateReportedLocale() {
        let locale = NSLocale.currentLocale().localeIdentifier
        Crashlytics.sharedInstance().setObjectValue(locale, forKey: "locale")
    }
}
