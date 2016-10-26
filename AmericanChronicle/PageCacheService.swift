protocol PageCacheServiceInterface {
    func fileURLForRemoteURL(_ remoteURL: URL) -> URL?
    func cacheFileURL(_ fileURL: URL, forRemoteURL remoteURL: URL)
}

final class PageCacheService: PageCacheServiceInterface {
    fileprivate var completedDownloads: [URL: URL] = [:]
    func fileURLForRemoteURL(_ remoteURL: URL) -> URL? {
        return completedDownloads[remoteURL]
    }
    func cacheFileURL(_ fileURL: URL, forRemoteURL remoteURL: URL) {
        completedDownloads[remoteURL] = fileURL
    }
}
