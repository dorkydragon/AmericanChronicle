import XCTest
@testable import AmericanChronicle
import Alamofire
import ObjectMapper

class PageWebServiceTests: XCTestCase {

    var subject: PageWebService!
    var manager: FakeSessionManager!

    // MARK: Setup and Teardown

    override func setUp() {

        super.setUp()
        manager = FakeSessionManager()
        subject = PageWebService(manager: manager)
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Tests

    func testThat_whenNewDownloadIsRequested_itStartsTheDownload() {

        // when

        let exp = expectation(description: "download_was_called")
        manager.download_wasCalled_handler = {
            exp.fulfill()
        }
        subject.downloadPage(withRemoteURL: URL(string: "http://notarealurl.com")!, contextID: "") { _, _ in }
        waitForExpectations(timeout: 0.2, handler: nil)

        // then

        XCTAssertEqual(manager.download_callLog[0].url as! String, "http://notarealurl.com")
    }

    func testThat_whenAnOngoingDownloadIsRequested_itDoesNotStartTheDownload() {

        // given

        let url = URL(string: "http://notarealurl.com")!

        // Make the first request, which *does* start a download.
        let contextA = "contextA"

        let expectDownloadToBeCalled = expectation(description: "Expect download to be called")
        manager.download_wasCalled_handler = {
            expectDownloadToBeCalled.fulfill()
        }
        subject.downloadPage(withRemoteURL: url, contextID: contextA) { _, _ in }
        waitForExpectations(timeout: 0.2, handler: nil)

        // when

        // Make the second request, which doesn't start a download.
        let contextB = "contextB"

        var downloadWasCalled = false
        manager.download_wasCalled_handler = {
            downloadWasCalled = true
        }

        let expectGroupToFinishWork = expectation(description: "Expect queue group to finish its work")
        subject.group.notify(queue: .main) {
            expectGroupToFinishWork.fulfill()
        }

        subject.downloadPage(withRemoteURL: url, contextID: contextB) { _, _ in }
        waitForExpectations(timeout: 0.2, handler: nil)

        // then

        XCTAssertFalse(downloadWasCalled)
    }

    func testThat_whenAnOngoingDownloadIsRequested_andTheProvidedContextIDIsAlreadyRecorded_itReturnsAnError() {

        // given

        let url = URL(string: "http://notarealurl.com")!

        // Make the first request.

        let contextA = "contextA"
        subject.downloadPage(withRemoteURL: url, contextID: contextA) { _, _ in }

        // when

        // Make the second request, which returns an error.

        let expectGroupToFinishWork = expectation(description: "Expect queue group to finish its work")
        subject.group.notify(queue: .main) {
            expectGroupToFinishWork.fulfill()
        }

        var returnedError: NSError?
        subject.downloadPage(withRemoteURL: url, contextID: contextA) { _, err in
            returnedError = err as NSError?
        }
        waitForExpectations(timeout: 0.2, handler: nil)

        // then

        XCTAssertNotNil(returnedError)
    }

    func testThat_whenAnOngoingDownloadIsRequested_andTheProvidedContextIDIsNotAlreadyRecorded_itDoesNotReturnAnError() {

        // given

        let urlString = "http://notarealurl.com"
        let contextID = "abcd-efgh"
        subject.downloadPage(withRemoteURL: URL(string: urlString)!, contextID: contextID) { _, _ in }

        // when

        let exp = expectation(description: "completionHandler_wasCalled")
        var error: NSError?
        subject.downloadPage(withRemoteURL: URL(string: urlString)!, contextID: contextID) { _, err in
            error = err as NSError?
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.1, handler: nil)

        // then

        XCTAssertNotNil(error)
    }

    func testThat_whenADownloadSucceeds_itTriggersTheHandlersThatRequestedTheDownload() {

        // given

        let remoteURLString = "http://notarealurl.com"
        let remoteURL = URL(string: remoteURLString)!

        var urlOne: URL?
        let downloadOneFinished = XCTestExpectation(description: "Download one finished")
        subject.downloadPage(withRemoteURL: remoteURL, contextID: "abcd-efgh") { results, _ in
            urlOne = results
            downloadOneFinished.fulfill()
        }

        var urlTwo: URL?
        let downloadTwoFinished = XCTestExpectation(description: "Download two finished")
        subject.downloadPage(withRemoteURL: remoteURL, contextID: "efgh-ijkl") { results, _ in
            urlTwo = results
            downloadTwoFinished.fulfill()
        }

        var urlThree: URL?
        let downloadThreeFinished = XCTestExpectation(description: "Download three finished")
        subject.downloadPage(withRemoteURL: remoteURL, contextID: "ijkl-mnop") { results, _ in
            urlThree = results
            downloadThreeFinished.fulfill()
        }

        let fileURL = URL(string: "file://my/downloads/file.pdf")!

        // when

        let expectRequestsToStart = XCTestExpectation(description: "Requests started")
        subject.group.notify(queue: .main) {
            print("[RP] Received group.notify")
            expectRequestsToStart.fulfill()
        }
        wait(for: [expectRequestsToStart], timeout: 2)

        manager.stubbedReturnDownloadRequest.finishWithRequest(nil,
                                                               response: nil,
                                                               destinationURL: fileURL,
                                                               error: nil)

        // then

        wait(for: [downloadOneFinished, downloadTwoFinished, downloadThreeFinished], timeout: 2)

        XCTAssertNotNil(urlOne)
        XCTAssertNotNil(urlTwo)
        XCTAssertNotNil(urlThree)
        XCTAssertEqual(urlOne, urlTwo)
        XCTAssertEqual(urlTwo, urlThree)
    }

    func testThat_whenADownloadFails_itTriggersTheHandlersThatRequestedTheDownload() {

        // given

        let remoteURLString = "http://notarealurl.com"
        let remoteURL = URL(string: remoteURLString)!

        var errorOne: NSError?
        let downloadOneFinished = XCTestExpectation(description: "Download one finished")
        subject.downloadPage(withRemoteURL: remoteURL, contextID: "abcd-efgh") { _, err in
            errorOne = err as NSError?
            downloadOneFinished.fulfill()
        }

        var errorTwo: NSError?
        let downloadTwoFinished = XCTestExpectation(description: "Download two finished")
        subject.downloadPage(withRemoteURL: remoteURL, contextID: "efgh-ijkl") { _, err in
            errorTwo = err as NSError?
            downloadTwoFinished.fulfill()
        }

        var errorThree: NSError?
        let downloadThreeFinished = XCTestExpectation(description: "Download three finished")
        subject.downloadPage(withRemoteURL: remoteURL, contextID: "ijkl-mnop") { _, err in
            errorThree = err as NSError?
            downloadThreeFinished.fulfill()
        }

        let fileURL = URL(string: "file://my/downloads/file.pdf")!
        let error = NSError(code: .invalidParameter, message: "")

        // when

        let expectRequestsToStart = XCTestExpectation(description: "Requests started")
        subject.group.notify(queue: .main) {
            expectRequestsToStart.fulfill()
        }
        wait(for: [expectRequestsToStart], timeout: 2)
        manager.stubbedReturnDownloadRequest.finishWithRequest(nil,
                                                               response: nil,
                                                               destinationURL: fileURL,
                                                               error: error)

        // then

        wait(for: [downloadOneFinished, downloadTwoFinished, downloadThreeFinished], timeout: 2)

        XCTAssertNotNil(errorOne)
        XCTAssertNotNil(errorTwo)
        XCTAssertNotNil(errorThree)
        XCTAssertEqual(errorOne, errorTwo)
        XCTAssertEqual(errorTwo, errorThree)
    }
}
