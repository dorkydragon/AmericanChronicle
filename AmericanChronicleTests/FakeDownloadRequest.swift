@testable import AmericanChronicle
import Alamofire

class FakeDownloadRequest: DownloadRequestProtocol {

    func response(queue: DispatchQueue?, completion: @escaping (DefaultDownloadResponse) -> Void) -> Self {
        return self
    }

    func cancel() {

    }
}
