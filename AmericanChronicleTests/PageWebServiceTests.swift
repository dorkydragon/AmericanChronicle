import XCTest
@testable import AmericanChronicle
import Alamofire
import ObjectMapper

class PageWebServiceTests: XCTestCase {

    var subject: PageWebService!
    var manager: FakeManager!

    // MARK: Setup and Teardown

    override func setUp() {

        super.setUp()
        manager = FakeManager()
        subject = PageWebService(manager: manager)
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: Tests

    func testThat_whenNewDownloadIsRequested_itStartsTheDownload() {

        // when

        let expectation = expectationWithDescription("download_was_called")
        manager.download_wasCalled_handler = {
            expectation.fulfill()
        }
        subject.downloadPage(URL(string: "http://notarealurl.com")!, contextID: "") { _, _ in }
        waitForExpectationsWithTimeout(0.2, handler: nil)

        // then

        XCTAssertEqual(manager.download_wasCalled_withURLString?.URLString, "http://notarealurl.com")
    }

    func testThat_whenAnOngoingDownloadIsRequested_itDoesNotStartTheDownload() {

        // given

        let url = URL(string: "http://notarealurl.com")!

        // Make the first request, which *does* start a download.
        let contextA = "contextA"

        let expectDownloadToBeCalled = expectationWithDescription("Expect download to be called")
        manager.download_wasCalled_handler = {
            expectDownloadToBeCalled.fulfill()
        }
        subject.downloadPage(url, contextID: contextA) { _, _ in }
        waitForExpectationsWithTimeout(0.2, handler: nil)

        // when

        // Make the second request, which doesn't start a download.
        let contextB = "contextB"

        var downloadWasCalled = false
        manager.download_wasCalled_handler = {
            downloadWasCalled = true
        }

        let expectGroupToFinishWork = expectationWithDescription("Expect queue group to finish its work")
        dispatch_group_notify(subject.group, dispatch_get_main_queue()) {
            expectGroupToFinishWork.fulfill()
        }

        subject.downloadPage(URL, contextID: contextB) { _, _ in }
        waitForExpectationsWithTimeout(0.2, handler: nil)

        // then

        XCTAssertFalse(downloadWasCalled)
    }

    func testThat_whenAnOngoingDownloadIsRequested_andTheProvidedContextIDIsAlreadyRecorded_itReturnsAnError() {

        // given

        let url = URL(string: "http://notarealurl.com")!

        // Make the first request.

        let contextA = "contextA"
        subject.downloadPage(url, contextID: contextA) { _, _ in }

        // when

        // Make the second request, which returns an error.

        let expectGroupToFinishWork = expectationWithDescription("Expect queue group to finish its work")
        dispatch_group_notify(subject.group, dispatch_get_main_queue()) {
            expectGroupToFinishWork.fulfill()
        }

        var returnedError: NSError? = nil
        subject.downloadPage(url, contextID: contextA) { _, err in
            returnedError = err as? NSError
        }
        waitForExpectationsWithTimeout(0.2, handler: nil)

        // then

        XCTAssertNotNil(returnedError)
    }

    func testThat_whenAnOngoingDownloadIsRequested_andTheProvidedContextIDIsNotAlreadyRecorded_itDoesNotReturnAnError() {

        // given

        let urlString = "http://notarealurl.com"
        let contextID = "abcd-efgh"
        subject.downloadPage(URL(string: urlString)!, contextID: contextID) { _, _ in }

        // when

        let expectation = expectationWithDescription("completionHandler_wasCalled")
        var error: NSError? = nil
        subject.downloadPage(URL(string: urlString)!, contextID: contextID) { _, err in
            error = err as? NSError
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(0.1, handler: nil)

        // then

        XCTAssertNotNil(error)
    }

    func testThat_whenADownloadSucceeds_itTriggersTheHandlersThatRequestedTheDownload() {

        // given

        let urlString = "http://notarealurl.com"

        var URLOne: URL?
        subject.downloadPage(URL(string: urlString)!, contextID: "abcd-efgh") { results, _ in
            URLOne = results
        }

        var URLTwo: URL?
        subject.downloadPage(URL(string: urlString)!, contextID: "efgh-ijkl") { results, _ in
            URLTwo = results
        }

        var URLThree: URL?
        subject.downloadPage(URL(string: urlString)!, contextID: "ijkl-mnop") { results, _ in
            URLThree = results
        }

        // when

        let expectSubjectGroupToEmpty = expectationWithDescription("empty_subject_group")
        dispatch_group_notify(subject.group, dispatch_get_main_queue()) {
            expectSubjectGroupToEmpty.fulfill()
        }
        waitForExpectationsWithTimeout(0.5, handler: nil)

        manager.stubbedReturnValue.finishWithRequest(nil, response: nil, data: nil, error: nil)

        // then

        XCTAssertEqual(URLOne, URLTwo)
        XCTAssertEqual(URLTwo, URLThree)
    }

    func testThat_whenADownloadFails_itTriggersTheHandlersThatRequestedTheDownload() {

        // given

        let urlString = "http://notarealurl.com"

        var errorOne: NSError?
        subject.downloadPage(URL(string: urlString)!, contextID: "abcd-efgh") { _, err in
            errorOne = err as? NSError
        }

        var errorTwo: NSError?
        subject.downloadPage(URL(string: urlString)!, contextID: "efgh-ijkl") { _, err in
            errorTwo = err as? NSError
        }

        var errorThree: NSError?
        subject.downloadPage(URL(string: urlString)!, contextID: "ijkl-mnop") { _, err in
            errorThree = err as? NSError
        }

        // when

        let expectSubjectGroupToEmpty = expectationWithDescription("empty_subject_group")
        dispatch_group_notify(subject.group, dispatch_get_main_queue()) {
            expectSubjectGroupToEmpty.fulfill()
        }
        waitForExpectationsWithTimeout(0.1, handler: nil)
        manager.stubbedReturnValue.finishWithRequest(nil, response: nil, data: nil, error: NSError(code: .InvalidParameter, message: ""))

        // then

        XCTAssertEqual(errorOne, errorTwo)
        XCTAssertEqual(errorTwo, errorThree)
    }
}
