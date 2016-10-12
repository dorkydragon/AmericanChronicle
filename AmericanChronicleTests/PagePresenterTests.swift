import XCTest
@testable import AmericanChronicle

class PagePresenterTests: XCTestCase {
    var subject: PagePresenter!
    var interactor: FakePageInteractor!
    var view: FakePageUserInterface!
    var wireframe: FakePageWireframe!
    override func setUp() {
        super.setUp()
        view = FakePageUserInterface()
        interactor = FakePageInteractor()
        subject = PagePresenter(interactor: interactor)
        wireframe = FakePageWireframe(delegate: FakePageWireframeDelegate(), presenter: subject)
        subject.wireframe = wireframe
    }

    func testThat_whenConfigureIsCalled_itTellsTheViewToShowItsLoadingIndicator() {
        subject.configure(userInterface: view,
                          withSearchTerm: "",
                          remoteDownloadURL: URL(string: "google.com")!,
                          id: "")
        XCTAssertTrue(view.showLoadingIndicator_wasCalled)
    }

    func testThat_whenConfigureIsCalled_itTellsTheInteractor() {
        subject.configure(userInterface: view,
                          withSearchTerm: "",
                          remoteDownloadURL: URL(string: "google.com")!,
                          id: "")
        XCTAssert(interactor.startDownload_wasCalled)
    }

    func testThat_whenADownloadFinishes_itTellsTheViewToHideItsLoadingIndicator() {
        subject.configure(userInterface: view,
                          withSearchTerm: "",
                          remoteDownloadURL: URL(string: "google.com")!,
                          id: "")
        subject.downloadDidFinish(forRemoteURL: URL(string: "http://google.com")!, withFileURL: nil, error: nil)
        XCTAssertTrue(view.hideLoadingIndicator_wasCalled)
    }

    func testThat_whenADownloadFinishesWithoutAnError_itPassesThePDFToTheView() {
        let requestURL = URL(string: "http://www.blah.spat")!
        let currentBundle = Bundle(for: PagePresenterTests.self)
        let returnedFilePathString = currentBundle.path(forResource: "seq-1", ofType: "pdf")
        let returnedFileURL = URL(fileURLWithPath: returnedFilePathString ?? "")
        XCTAssertNotNil(returnedFileURL)

        subject.configure(userInterface: view,
                          withSearchTerm: "",
                          remoteDownloadURL: URL(string: "google.com")!,
                          id: "")
        subject.downloadDidFinish(forRemoteURL: requestURL, withFileURL: returnedFileURL, error: nil)
        XCTAssertNotNil(view.pdfPage)
    }

    func testThat_whenADownloadFinishesWithAnError_itTellsTheViewToShowTheErrorMessage() {
        let requestURL = URL(string: "http://www.blah.spat")!
        let returnedError = NSError(domain: "", code: 0, userInfo: nil)
        subject.configure(userInterface: view,
                          withSearchTerm: "",
                          remoteDownloadURL: URL(string: "google.com")!,
                          id: "")
        subject.downloadDidFinish(forRemoteURL: requestURL, withFileURL: nil, error: returnedError)
        XCTAssertNotNil(view.showError_wasCalled_withTitle)
    }

    func testThat_whenTheUserTapsCancel_itTellsTheInteractorToCancel() {
        subject.configure(userInterface: view,
                          withSearchTerm: "",
                          remoteDownloadURL: URL(string: "google.com")!,
                          id: "")
        subject.userDidTapCancel()
        XCTAssert(interactor.cancelDownload_wasCalled)
    }

    func testThat_whenTheUserTapsCancel_itTellsTheWireframe() {
        subject.userDidTapCancel()
        XCTAssert(wireframe.dismissPageScreen_wasCalled)
    }
}
