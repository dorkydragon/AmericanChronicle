final class KeyboardService: NSObject {

    fileprivate var frameChangeHandlers: [String: (CGRect?) -> Void] = [:]

    static let sharedInstance = KeyboardService()
    fileprivate let notificationCenter: NotificationCenter
    fileprivate(set) var keyboardFrame: CGRect? {
        didSet {
            if keyboardFrame != oldValue {
                for (_, handler) in frameChangeHandlers {
                    handler(keyboardFrame)
                }
            }
        }
    }

    init(notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.notificationCenter = notificationCenter
        super.init()
    }

    func applicationDidFinishLaunching() {
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillShow(_:)),
                                       name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillHide(_:)),
                                       name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func keyboardWillShow(_ notification: Notification) {
        let keyboardFrameEnd = (notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        keyboardFrame = keyboardFrameEnd?.cgRectValue
    }

    func keyboardWillHide(_ notification: Notification) {
        keyboardFrame = nil
    }

    func addFrameChangeHandler(_ identifier: String, handler: @escaping (CGRect?) -> Void) {
        frameChangeHandlers[identifier] = handler
    }

    func removeFrameChangeHandler(_ identifier: String) {
        frameChangeHandlers[identifier] = nil
    }

    deinit {
        notificationCenter.removeObserver(self)
    }
}
