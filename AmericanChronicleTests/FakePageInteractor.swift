@testable import AmericanChronicle

class FakePageInteractor: NSObject, PageInteractorInterface {

    // MARK: Test stuff

    var startDownload_wasCalled = false
    var cancelDownload_wasCalled = false

    // MARK: PageInteractorInterface conformance

    var delegate: PageInteractorDelegate?

    func startDownload(withRemoteURL: URL) {
        startDownload_wasCalled = true
    }

    func cancelDownload(withRemoteURL: URL) {
        cancelDownload_wasCalled = true
    }

    func isDownloadInProgress(withRemoteURL: URL) -> Bool {
        return false
    }

    func startOCRCoordinatesRequest(withID: String) {}
}
