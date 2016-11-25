@testable import AmericanChronicle

class FakePageInteractorDelegate: PageInteractorDelegate {

    // MARK: Test stuff

    var downloadDidFinish_invokedWith_remoteURL: URL? = nil
    var downloadDidFinish_invokedWith_fileURL: URL? = nil
    var downloadDidFinish_invokedWith_error: NSError? = nil

    var requestDidFinish_invokedWith_coordinates: OCRCoordinates? = nil
    var requestDidFinish_invokedWith_error: NSError? = nil

    // MARK: PageInteractorDelegate conformance

    func downloadDidFinish(forRemoteURL remoteURL: URL, withFileURL fileURL: URL?, error: NSError?) {
        downloadDidFinish_invokedWith_remoteURL = remoteURL
        downloadDidFinish_invokedWith_fileURL = fileURL
        downloadDidFinish_invokedWith_error = error
    }

    func requestDidFinish(withOCRCoordinates coordinates: OCRCoordinates?, error: NSError?) {
        requestDidFinish_invokedWith_coordinates = coordinates
        requestDidFinish_invokedWith_error = error
    }
}
