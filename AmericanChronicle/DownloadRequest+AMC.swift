import Alamofire

protocol DownloadRequestProtocol {
    func response(queue: DispatchQueue?, completion: @escaping (DefaultDownloadResponse) -> Void) -> Self
    func cancel()
}

extension DownloadRequest: DownloadRequestProtocol {
    func response(queue: DispatchQueue?, completion: @escaping (DefaultDownloadResponse) -> Void) -> Self {
        return response(queue: queue, completionHandler: completion)
    }
}
