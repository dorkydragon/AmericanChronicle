@testable import AmericanChronicle

class FakePageCacheService: PageCacheServiceInterface {
    var stubbed_fileURL: URL?
    func fileURLForRemoteURL(_ remoteURL: URL) -> URL? {
        return stubbed_fileURL
    }

    func cacheFileURL(_ fileURL: URL, forRemoteURL remoteURL: URL) {

    }
}
