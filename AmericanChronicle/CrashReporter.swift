import Fabric
import Crashlytics

struct CrashReporter {
    static let sharedInstance = CrashReporter()
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
