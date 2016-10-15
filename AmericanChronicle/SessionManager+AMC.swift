import Alamofire

protocol SessionManagerProtocol {
    func download(_ url: URLConvertible, to destination: DownloadRequest.DownloadFileDestination?) -> DownloadRequestProtocol
    func beginRequest(_ request: URLRequestConvertible) -> DataRequestProtocol
}

extension SessionManager: SessionManagerProtocol {

    func beginRequest(_ urlRequest: URLRequestConvertible) -> DataRequestProtocol {
        return request(urlRequest)
    }

    func download(_ url: URLConvertible, to destination: DownloadRequest.DownloadFileDestination?) -> DownloadRequestProtocol {
            return download(url,
                            method: .get,
                            parameters: nil,
                            encoding: URLEncoding.default,
                            headers: nil,
                            to: destination)
    }
}
