@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let rootWireframe = SearchWireframe()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Reporter.sharedInstance.applicationDidFinishLaunching()
        KeyboardService.sharedInstance.applicationDidFinishLaunching()
        window = UIWindow(frame: UIScreen.main.bounds)
        rootWireframe.beginAsRootFromWindow(window)
        window?.makeKeyAndVisible()
        Appearance.apply()
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        Reporter.sharedInstance.applicationDidBecomeActive()
    }
}
