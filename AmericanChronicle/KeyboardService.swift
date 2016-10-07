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

    func keyboardWillShow(_ notification: Notification) {
        let keyboardFrameEnd = (notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        keyboardFrame = keyboardFrameEnd?.cgRectValue
    }

    func keyboardWillHide(_ notification: Notification) {
        keyboardFrame = nil
    }

    func addFrameChangeHandler(identifier: String, handler: @escaping (CGRect?) -> Void) {
        frameChangeHandlers[identifier] = handler
    }

    func removeFrameChangeHandler(_ identifier: String) {
        frameChangeHandlers[identifier] = nil
    }

    // MARK: Deinit method

    deinit {
        notificationCenter.removeObserver(self)
    }
}
