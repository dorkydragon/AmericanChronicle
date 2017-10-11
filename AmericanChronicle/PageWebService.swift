import Alamofire

protocol PageWebServiceInterface {
    func downloadPage(withRemoteURL: URL, contextID: String, completion: @escaping (URL?, Error?) -> Void)
    func cancelDownload(withRemoteURL: URL, contextID: String)
    func isDownloadInProgress(withRemoteURL: URL) -> Bool
}

typealias ContextID = String

struct ActivePageDownload {
    let request: DownloadRequestProtocol
    var requesters: [ContextID: PageDownloadRequester]
}

struct PageDownloadRequester {
    let contextID: ContextID
    let completion: (URL?, Error?) -> Void
}

/// Doesn't allow more than one instance of any download, but keeps track of the completion blocks
/// when there are duplicates.
final class PageWebService: PageWebServiceInterface {

    // MARK: Properties

    let group = DispatchGroup()
    var activeDownloads: [URL: ActivePageDownload] = [:]
    fileprivate let manager: SessionManagerProtocol
    fileprivate let queue = DispatchQueue(label: "com.ryanipete.AmericanChronicle.PageWebService",
                                          attributes: [])

    // MARK: Init methods

    init(manager: SessionManagerProtocol = SessionManager()) {
        self.manager = manager
    }

    // MARK: PageWebServiceInterface conformance

    func downloadPage(withRemoteURL remoteURL: URL,
                      contextID: String,
                      completion: @escaping (URL?, Error?) -> Void) {
        // Note: Resumes are not currently supported by chroniclingamerica.loc.gov.
        // Note: Estimated filesize isn't currently supported by chroniclingamerica.loc.gov

        var fileURL: URL?
        let destination: (URL, HTTPURLResponse) -> (URL, DownloadRequest.DownloadOptions) = { (temporaryURL, response) in

            let documentsDirectoryURL = FileManager.defaultDocumentDirectoryURL
            let remotePath = remoteURL.path
            fileURL = (documentsDirectoryURL as URL?)?.appendingPathComponent(remotePath).standardizedFileURL
            do {
                if let fileDirectoryURL = fileURL?.deletingLastPathComponent() {
                    let manager = FileManager.default
                    try manager.createDirectory(at: fileDirectoryURL,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
                }
            } catch let error {
                print("ERROR: \(error)")
            }

            return (fileURL ?? temporaryURL, .createIntermediateDirectories)
        }
        queue.async(group: group) {

            if var activeDownload = self.activeDownloads[remoteURL] {
                if activeDownload.requesters[contextID] != nil {
                    DispatchQueue.main.async {
                        let error = NSError(code: .duplicateRequest,
                                            message: NSLocalizedString("Tried to send a duplicate request.",
                                                                       comment: "Tried to send a duplicate request."))
                        completion(nil, error)
                    }
                } else {
                    let requester = PageDownloadRequester(contextID: contextID,
                                                          completion: completion)
                    activeDownload.requesters[contextID] = requester
                }
            } else {
                let requester = PageDownloadRequester(contextID: contextID,
                                                      completion: completion)
                let request = self.manager
                    .download(remoteURL.absoluteString, to: destination)
                    .response(queue: nil) { [weak self] (response: DefaultDownloadResponse) in
                        if let error = response.error as NSError? {
                            if error.code == NSFileWriteFileExistsError {
                                // Not a real error, the file was found on disk.
                                self?.finishRequest(withRemoteURL: remoteURL, fileURL: fileURL, error: nil)

                            } else {
                                self?.finishRequest(withRemoteURL: remoteURL, fileURL: fileURL, error: error)
                            }
                        }
                    }

                let download = ActivePageDownload(request: request,
                                                  requesters: [contextID: requester])
                self.activeDownloads[remoteURL] = download
            }
        }
    }

    func isDownloadInProgress(withRemoteURL remoteURL: URL) -> Bool {
        var isInProgress = false
        queue.sync {
            isInProgress = self.activeDownloads[remoteURL] != nil
        }
        return isInProgress
    }

    func cancelDownload(withRemoteURL remoteURL: URL, contextID: String) {
        queue.async(group: group) {
            var activeDownload = self.activeDownloads[remoteURL]
            let requester = activeDownload?.requesters[contextID]
            if let requesters = activeDownload?.requesters, requesters.isEmpty {
                activeDownload?.request.cancel()
            } else {
                requester?.completion(nil, NSError(domain: "", code: -999, userInfo: nil))
                _ = activeDownload?.requesters.removeValue(forKey: contextID)
                self.activeDownloads[remoteURL] = activeDownload
            }
        }
    }

    // MARK: Private methods

    fileprivate func finishRequest(withRemoteURL remoteURL: URL, fileURL: URL?, error: NSError?) {
        queue.async(group: group) {
            if let activeDownload = self.activeDownloads[remoteURL] {
                DispatchQueue.main.async {
                    for (_, requester) in activeDownload.requesters {
                        requester.completion(fileURL, nil)
                    }
                    self.activeDownloads[remoteURL] = nil
                }
            }
        }
    }
}
