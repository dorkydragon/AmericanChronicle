@testable import AmericanChronicle

class FakePageInteractor: NSObject, PageInteractorInterface {

    var delegate: PageInteractorDelegate?

    var startDownload_wasCalled = false
    func startDownloadWithRemoteURL(_ remoteURL: URL) {
        startDownload_wasCalled = true
    }

    var cancelDownload_wasCalled = false
    func cancelDownloadWithRemoteURL(_ remoteURL: URL) {
        cancelDownload_wasCalled = true
    }

    func isDownloadWithRemoteURLInProgress(_ remoteURL: URL) -> Bool {
        return false
    }

    func startOCRCoordinatesRequestWithID(_ id: String) {
    }
}
