@testable import AmericanChronicle

class FakePageUserInterface: NSObject, PageUserInterface {

    // mark: Test stuff

    var doneCallback: ((Void) -> ())?
    var shareCallback: ((Void) -> ())?
    var cancelCallback: ((Void) -> ())?

    var showError_wasCalled_withTitle: String?
    var showError_wasCalled_withMessage: String?
    var showLoadingIndicator_wasCalled = false
    var hideLoadingIndicator_wasCalled = false

    // mark: PageUserInterface conformance

    var pdfPage: CGPDFPage?
    var highlights: OCRCoordinates?
    var delegate: PageUserInterfaceDelegate?

    func showErrorWithTitle(_ title: String?, message: String?) {
        showError_wasCalled_withTitle = title
        showError_wasCalled_withMessage = message
    }

    func showLoadingIndicator() {
        showLoadingIndicator_wasCalled = true
    }

    func setDownloadProgress(_ progress: Float) {

    }

    func hideLoadingIndicator() {
        hideLoadingIndicator_wasCalled = true
    }
}
