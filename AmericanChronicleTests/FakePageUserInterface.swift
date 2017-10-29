@testable import AmericanChronicle
import XCTest

class FakePageUserInterface: NSObject, PageUserInterface {

    // MARK: Test stuff

    var doneCallback: (() -> Void)?
    var shareCallback: (() -> Void)?
    var cancelCallback: (() -> Void)?

    var showError_callLog: [(title: String?, message: String?)] = []
    private var showError_expectation: XCTestExpectation?
    func newShowErrorExpectation() -> XCTestExpectation {
        showError_expectation = XCTestExpectation(description: "Did call showErrorWithTitle(_:message:)")
        return showError_expectation!
    }

    var showLoadingIndicator_wasCalled = false

    var hideLoadingIndicator_wasCalled = false
    private var hideLoadingIndicator_expectation: XCTestExpectation?
    func newHideLoadingIndicatorExpectation() -> XCTestExpectation {
        hideLoadingIndicator_expectation = XCTestExpectation(description: "Did call hideLoadingIndicator()")
        return hideLoadingIndicator_expectation!
    }

    private var setPDFPage_expectation: XCTestExpectation?
    func newSetPDFPageExpectation() -> XCTestExpectation {
        setPDFPage_expectation = XCTestExpectation(description: "Did set pdfPage")
        return setPDFPage_expectation!
    }

    // MARK: PageUserInterface conformance

    var pdfPage: CGPDFPage? {
        didSet {
            setPDFPage_expectation?.fulfill()
            setPDFPage_expectation = nil
        }
    }
    var highlights: OCRCoordinates?
    weak var delegate: PageUserInterfaceDelegate?

    func showErrorWithTitle(_ title: String?, message: String?) {
        showError_callLog.append((title, message))
        showError_expectation?.fulfill()
        showError_expectation = nil
    }

    func showLoadingIndicator() {
        showLoadingIndicator_wasCalled = true
    }

    func setDownloadProgress(_ progress: Float) {

    }

    func hideLoadingIndicator() {
        hideLoadingIndicator_wasCalled = true
        hideLoadingIndicator_expectation?.fulfill()
        hideLoadingIndicator_expectation = nil
    }
}
