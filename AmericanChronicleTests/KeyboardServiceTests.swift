import XCTest
@testable import AmericanChronicle


class KeyboardServiceTests: XCTestCase {
    var subject: KeyboardService!
    var notificationCenter: NotificationCenter!

    override func setUp() {
        super.setUp()
        notificationCenter = NotificationCenter()
        subject = KeyboardService(notificationCenter: notificationCenter)
        subject.applicationDidFinishLaunching()
    }

    fileprivate func postKeyboardWillShowNotification(_ endRect: CGRect) {
        let rectVal = NSValue(cgRect: endRect)
        let userInfo = [UIKeyboardFrameEndUserInfoKey: rectVal]
        notificationCenter.post(name: NSNotification.Name.UIKeyboardWillShow, object: nil, userInfo: userInfo)
    }

    func testThat_whenAKeyboardShows_itUpdatesTheKeyboardFrame() {
        let rect = CGRect(x: 15, y: 15, width: 300, height: 100)
        postKeyboardWillShowNotification(rect)
        XCTAssertEqual(subject.keyboardFrame, rect)
    }

    func testThat_whenTheKeyboardFrameChanges_itCallsEachHandlerWithTheNewFrame() {
        let handlerOneID = "handlerOne"
        var handlerOne_wasCalled_withRect: CGRect?
        let handlerOne = { rect in
            handlerOne_wasCalled_withRect = rect
        }
        subject.addFrameChangeHandler(id: handlerOneID, handler: handlerOne)

        var handlerTwo_wasCalled_withRect: CGRect?
        let handlerTwo = { rect in
            handlerTwo_wasCalled_withRect = rect
        }
        let handlerTwoID = "handlerTwo"
        subject.addFrameChangeHandler(id: handlerTwoID, handler: handlerTwo)

        let rect = CGRect(x: 15, y: 15, width: 300, height: 100)
        postKeyboardWillShowNotification(rect)

        XCTAssertEqual(handlerOne_wasCalled_withRect, rect)
        XCTAssertEqual(handlerTwo_wasCalled_withRect, rect)
    }
}
