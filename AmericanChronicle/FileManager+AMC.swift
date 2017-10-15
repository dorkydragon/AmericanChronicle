extension FileManager {
    class var defaultDocumentDirectoryURL: URL? {
        return FileManager.default.urls(for: .documentDirectory,
                                                               in: .userDomainMask).first
    }

    class var defaultApplicationDirectoryURL: URL? {
        return FileManager.default.urls(for: .applicationDirectory,
                                                               in: .userDomainMask).first
    }

    class var defaultLibraryDirectoryURL: URL? {
        return FileManager.default.urls(for: .libraryDirectory,
                                                               in: .userDomainMask).first
    }

    class var defaultCachesDirectoryURL: URL? {
        return FileManager.default.urls(for: .cachesDirectory,
                                                               in: .userDomainMask).first
    }

    class var defaultDownloadsDirectoryURL: URL? {
        return FileManager.default.urls(for: .downloadsDirectory,
                                                               in: .userDomainMask).first
    }

    class var defaultItemReplacementDirectoryURL: URL? {
        return FileManager.default.urls(for: .itemReplacementDirectory,
                                                               in: .userDomainMask).first
    }

    class func printAllDirectoryURLs() {
        print("[RP] defaultDocumentDirectoryURL: \(String(describing: defaultDocumentDirectoryURL))")
        print("[RP] defaultApplicationDirectoryURL: \(String(describing: defaultApplicationDirectoryURL))")
        print("[RP] defaultLibraryDirectoryURL: \(String(describing: defaultLibraryDirectoryURL))")
        print("[RP] defaultCachesDirectoryURL: \(String(describing: defaultCachesDirectoryURL))")
        print("[RP] defaultDownloadsDirectoryURL: \(String(describing: defaultDownloadsDirectoryURL))")
        print("[RP] defaultItemReplacementDirectoryURL: \(String(describing: defaultItemReplacementDirectoryURL))")
    }

    class var contentsOfTemporaryDirectory: [String] {
        let tempDirURL = NSTemporaryDirectory()
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: tempDirURL)
            return contents
        } catch let error {
            print("error: \(error)")
        }
        return []
    }

    class func fullURLForTemporaryFileWithName(_ name: String) -> URL? {
        let tempDirURL = URL(fileURLWithPath: NSTemporaryDirectory())
        let fullURL = tempDirURL.appendingPathComponent(name)
        return fullURL
    }
}
