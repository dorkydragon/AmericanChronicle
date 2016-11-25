import XCTest
import ObjectMapper
@testable import AmericanChronicle

class PageInteractorTests: XCTestCase {
    var subject: PageInteractor!
    var subjectDelegate: FakePageInteractorDelegate!
    var pageService: FakePageWebService!
    var cacheService: FakePageCacheService!
    var coordinatesService: FakeOCRCoordinatesWebService!

    // MARK: Setup and Teardown

    override func setUp() {
        super.setUp()
        pageService = FakePageWebService()
        cacheService = FakePageCacheService()
        coordinatesService = FakeOCRCoordinatesWebService()
        subject = PageInteractor(pageService: pageService,
                                 cachedPageService: cacheService,
                                 coordinatesService: coordinatesService)
        subjectDelegate = FakePageInteractorDelegate()
        subject.delegate = subjectDelegate
    }

    // MARK: Tests

    func testThat_ifThePageIsNotCached_startDownload_startsAPageServiceRequest() {

        // given

        let URL = Foundation.URL(string: "http://notrealurl.com")!

        // when

        subject.startDownload(withRemoteURL: URL)

        // then

        XCTAssertEqual(pageService.downloadPage_arguments_URL, URL)
    }

    func testThat_ifThePageIsCached_startDownload_doesNotStartAPageServiceRequest() {

        // given

        cacheService.stubbed_fileURL = URL(string: "file://doesnotexist")

        // when

        subject.startDownload(withRemoteURL: URL(string: "http://notrealurl.com")!)

        // then

        XCTAssertNil(pageService.downloadPage_arguments_URL)
    }

    func testThat_ifThePageIsCached_startDownload_returnsAFileURLImmediately() {

        // given

        cacheService.stubbed_fileURL = URL(string: "file://notareal/file.txt")

        // when

        subject.startDownload(withRemoteURL: URL(string: "http://notrealurl.com")!)

        // then

        XCTAssertEqual(subjectDelegate.downloadDidFinish_invokedWith_fileURL, cacheService.stubbed_fileURL)
    }

    func testThat_onPageServiceRequestSuccess_theDelegateIsCalledWithTheFileURL() {

        // when

        subject.startDownload(withRemoteURL: URL(string: "http://notrealurl.com")!)
        let stubbedFileURL = URL(string: "file://somewhere")!
        pageService.fakeSuccess(withURL: stubbedFileURL)

        // then

        XCTAssertEqual(subjectDelegate.downloadDidFinish_invokedWith_fileURL, stubbedFileURL)
    }

    func testThat_onPageServiceRequestFailure_theDelegateIsCalledWithTheError() {

        // when

        subject.startDownload(withRemoteURL: URL(string: "http://notrealurl.com")!)
        let stubbedError = NSError(domain: "", code: 0, userInfo: nil)
        pageService.fakeFailure(withError: stubbedError)

        // then

        XCTAssertEqual(subjectDelegate.downloadDidFinish_invokedWith_error, stubbedError)
    }

    func testThat_cancelDownload_callsThePageServiceWithTheURL() {

        // when

        let remoteURL = URL(string: "http://notrealurl.com")!
        subject.cancelDownload(withRemoteURL: remoteURL)

        // then

        XCTAssertEqual(pageService.cancelDownload_arguments_URL, remoteURL)
    }

    func testThat_isDownloadInProgress_returnsTheStatusReportedByThePageService() {

        // given

        pageService.stubbed_isDownloadInProgress = true

        // when

        let isInProgress = subject.isDownloadInProgress(withRemoteURL: URL(string: "http://notrealurl.com")!)

        // then

        XCTAssertTrue(isInProgress)
    }

    func testThat_startOCRCoordinatesRequest_callsTheOCRCoordinatesServiceWithTheID() {

        // when

        let requestID = "sn83045487"
        subject.startOCRCoordinatesRequest(withID: requestID)

        // then

        XCTAssertEqual(coordinatesService.startRequest_wasCalled_withID, requestID)
    }

    func testThat_onOCRCoordinatesRequestSuccess_theDelegateIsCalledWithTheCoordinates() {

        // when

        subject.startOCRCoordinatesRequest(withID: "")
        let expectedCoordinates = OCRCoordinates(map: Map(mappingType: .fromJSON, JSON: [:]))
        coordinatesService.startRequest_wasCalled_withCompletionHandler?(expectedCoordinates, nil)

        // then

        XCTAssertEqual(subjectDelegate.requestDidFinish_invokedWith_coordinates, expectedCoordinates)
    }

    func testThat_onOCRCoordinatesRequestFailure_theDelegateIsCalledWithTheError() {

        // when

        subject.startOCRCoordinatesRequest(withID: "")
        let expectedError = NSError(code: .duplicateRequest, message: nil)
        coordinatesService.startRequest_wasCalled_withCompletionHandler?(nil, expectedError)

        // then

        XCTAssertEqual(subjectDelegate.requestDidFinish_invokedWith_error, expectedError)
    }
}
