@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let rootWireframe = SearchWireframe()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CrashReporter.sharedInstance.applicationDidFinishLaunching()
        KeyboardService.sharedInstance.applicationDidFinishLaunching()
        AMCAppearance.apply()

        window = UIWindow(frame: UIScreen.main.bounds)
        rootWireframe.beginAsRootFromWindow(window)
        window?.makeKeyAndVisible()

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        CrashReporter.sharedInstance.applicationDidBecomeActive()
    }
}
