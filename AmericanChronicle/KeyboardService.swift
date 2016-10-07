/// A class that keeps track of the keyboard's current state.
///
/// It also provides a block-based interface for keyboard events.
///
/// ## To use:
///
/// Call `applicationDidFinishLaunching()` from your app delegate's
/// `applicationDidFinishLaunching:withOptions:` method.
///
/// In your view controller (or whatever object needs to know about
/// keyboard frame changes), provide a handler w/ a unique ID. For
/// example:
///
///     fileprivate let uniqueID = "abcd"
///     override init(...) {
///         super.init(...)
///         KeyboardService.sharedInstance.addFrameChangeHandler(id: uniqueID) { frame in
///             // Move some views around...
///         }
///     }
///
/// And don't forget to remove the handler when you're done. Use the same
/// identifier that you used when you added the handler:
///
///     deinit {
///         KeyboardService.sharedInstance.removeFrameChangeHandler(id: uniqueID)
///     }
final class KeyboardService: NSObject {

    // MARK: Properties

    static let sharedInstance = KeyboardService()

    fileprivate(set) var keyboardFrame: CGRect? {
        didSet {
            if keyboardFrame != oldValue {
                for (_, handler) in frameChangeHandlers {
                    handler(keyboardFrame)
                }
            }
        }
    }

    fileprivate var frameChangeHandlers: [String: (CGRect?) -> Void] = [:]
    fileprivate let notificationCenter: NotificationCenter

    // MARK: Init methods

    init(notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.notificationCenter = notificationCenter
        super.init()
    }

    // MARK: Internal methods

    func applicationDidFinishLaunching() {
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillShow(_:)),
                                       name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillHide(_:)),
                                       name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func addFrameChangeHandler(id: String, handler: @escaping (CGRect?) -> Void) {
        frameChangeHandlers[id] = handler
    }

    func removeFrameChangeHandler(id: String) {
        frameChangeHandlers[id] = nil
    }

    func keyboardWillShow(_ notification: Notification) {
        let keyboardFrameEnd = (notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        keyboardFrame = keyboardFrameEnd?.cgRectValue
    }

    func keyboardWillHide(_ notification: Notification) {
        keyboardFrame = nil
    }

    // MARK: Deinit method

    deinit {
        notificationCenter.removeObserver(self)
    }
}
