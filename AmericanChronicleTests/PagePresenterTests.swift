import XCTest
@testable import AmericanChronicle

class PagePresenterTests: XCTestCase {
    var subject: PagePresenter!
    var interactor: FakePageInteractor!
    var view: FakePageUserInterface!
    var wireframe: FakePageWireframe!

    // mark: Setup and Teardown

    override func setUp() {
        super.setUp()
        view = FakePageUserInterface()
        interactor = FakePageInteractor()
        subject = PagePresenter(interactor: interactor)
        wireframe = FakePageWireframe(delegate: FakePageWireframeDelegate(), presenter: subject)
        subject.wireframe = wireframe
    }

    // mark: Tests

    func testThat_whenConfigureIsCalled_itTellsTheViewToShowItsLoadingIndicator() {

        // when

        subject.configure(userInterface: view,
                          withSearchTerm: "",
                          remoteDownloadURL: URL(string: "google.com")!,
                          id: "")

        // then

        XCTAssertTrue(view.showLoadingIndicator_wasCalled)
    }

    func testThat_whenConfigureIsCalled_itTellsTheInteractor() {

        // when

        subject.configure(userInterface: view,
                          withSearchTerm: "",
                          remoteDownloadURL: URL(string: "google.com")!,
                          id: "")

        // then

        XCTAssert(interactor.startDownload_wasCalled)
    }

    func testThat_whenADownloadFinishes_itTellsTheViewToHideItsLoadingIndicator() {

        // given

        subject.configure(userInterface: view,
                          withSearchTerm: "",
                          remoteDownloadURL: URL(string: "google.com")!,
                          id: "")

        // when

        subject.downloadDidFinish(forRemoteURL: URL(string: "http://google.com")!, withFileURL: nil, error: nil)

        // then

        XCTAssertTrue(view.hideLoadingIndicator_wasCalled)
    }

    func testThat_whenADownloadFinishesWithoutAnError_itPassesThePDFToTheView() {

        // given

        let requestURL = URL(string: "http://www.blah.spat")!
        let currentBundle = Bundle(for: PagePresenterTests.self)
        let returnedFilePathString = currentBundle.path(forResource: "seq-1", ofType: "pdf")
        let returnedFileURL = URL(fileURLWithPath: returnedFilePathString ?? "")
        XCTAssertNotNil(returnedFileURL)

        subject.configure(userInterface: view,
                          withSearchTerm: "",
                          remoteDownloadURL: URL(string: "google.com")!,
                          id: "")

        // when

        subject.downloadDidFinish(forRemoteURL: requestURL, withFileURL: returnedFileURL, error: nil)

        // then

        XCTAssertNotNil(view.pdfPage)
    }

    func testThat_whenADownloadFinishesWithAnError_itTellsTheViewToShowTheErrorMessage() {

        // given

        let requestURL = URL(string: "http://www.blah.spat")!
        let returnedError = NSError(domain: "", code: 0, userInfo: nil)
        subject.configure(userInterface: view,
                          withSearchTerm: "",
                          remoteDownloadURL: URL(string: "google.com")!,
                          id: "")

        // when

        subject.downloadDidFinish(forRemoteURL: requestURL, withFileURL: nil, error: returnedError)

        // then

        XCTAssertNotNil(view.showError_wasCalled_withTitle)
    }

    func testThat_whenTheUserTapsCancel_itTellsTheInteractorToCancel() {

        // given

        subject.configure(userInterface: view,
                          withSearchTerm: "",
                          remoteDownloadURL: URL(string: "google.com")!,
                          id: "")

        // when

        subject.userDidTapCancel()

        // then

        XCTAssert(interactor.cancelDownload_wasCalled)
    }

    func testThat_whenTheUserTapsCancel_itTellsTheWireframe() {

        // when

        subject.userDidTapCancel()

        // then

        XCTAssert(wireframe.dismissPageScreen_wasCalled)
    }
}
