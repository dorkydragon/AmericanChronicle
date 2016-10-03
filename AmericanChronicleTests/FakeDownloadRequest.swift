@testable import AmericanChronicle
import Alamofire

class FakeDownloadRequest: DownloadRequestProtocol {

    func response(queue: DispatchQueue?, completionHandler: @escaping (DefaultDownloadResponse) -> Void) -> Self {
        return self
    }

    func cancel() {

    }
}
