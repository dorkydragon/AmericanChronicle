import Alamofire

protocol ManagerProtocol {
    func request(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?) -> DataRequestProtocol
    func download(_ url: URLConvertible, to destination: DownloadRequest.DownloadFileDestination?) -> DownloadRequestProtocol
}

extension SessionManager: ManagerProtocol {
    func request(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?) -> DataRequestProtocol {
        return self.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: nil)
    }

    func download(_ url: URLConvertible, to destination: DownloadRequest.DownloadFileDestination?) -> DownloadRequestProtocol {
            return self.download(url,
                                 method: .get,
                                 parameters: nil,
                                 encoding: URLEncoding.default,
                                 headers: nil,
                                 to: destination)
    }
}
