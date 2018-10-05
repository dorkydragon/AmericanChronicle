import XCTest
@testable import AmericanChronicle

class KeyboardServiceTests: XCTestCase {
    var subject: KeyboardService!
    var notificationCenter: NotificationCenter!

    // MARK: Setup and Teardown

    override func setUp() {
        super.setUp()
        notificationCenter = NotificationCenter()
        subject = KeyboardService(notificationCenter: notificationCenter)
        subject.applicationDidFinishLaunching()
    }

    // MARK: Tests

    func testThat_whenAKeyboardShows_itUpdatesTheKeyboardFrame() {

        // when

        let rect = CGRect(x: 15, y: 15, width: 300, height: 100)
        postKeyboardWillShowNotification(rect)

        // then

        XCTAssertEqual(subject.keyboardFrame, rect)
    }

    func testThat_whenTheKeyboardFrameChanges_itCallsEachHandlerWithTheNewFrame() {

        // given

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

        // when

        let rect = CGRect(x: 15, y: 15, width: 300, height: 100)
        postKeyboardWillShowNotification(rect)

        // then

        XCTAssertEqual(handlerOne_wasCalled_withRect, rect)
        XCTAssertEqual(handlerTwo_wasCalled_withRect, rect)
    }

    // Helpers

    private func postKeyboardWillShowNotification(_ endRect: CGRect) {
        let rectVal = NSValue(cgRect: endRect)
        let userInfo = [UIResponder.keyboardFrameEndUserInfoKey: rectVal]
        notificationCenter.post(name: UIResponder.keyboardWillShowNotification, object: nil, userInfo: userInfo)
    }
}
