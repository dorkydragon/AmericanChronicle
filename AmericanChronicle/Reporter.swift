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

    func logMessage(_ formattedString: String, arguments: [CVarArg] = []) {
        CLSLogv(formattedString, getVaList(arguments))
    }

    fileprivate func updateReportedLocale() {
        let locale = Locale.current.identifier
        Crashlytics.sharedInstance().setObjectValue(locale, forKey: "locale")
    }
}
