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
        print("defaultDocumentDirectoryURL: \(defaultDocumentDirectoryURL)")
        print("defaultApplicationDirectoryURL: \(defaultApplicationDirectoryURL)")
        print("defaultLibraryDirectoryURL: \(defaultLibraryDirectoryURL)")
        print("defaultCachesDirectoryURL: \(defaultCachesDirectoryURL)")
        print("defaultDownloadsDirectoryURL: \(defaultDownloadsDirectoryURL)")
        print("defaultItemReplacementDirectoryURL: \(defaultItemReplacementDirectoryURL)")
    }

    class var contentsOfTemporaryDirectory: [String] {
        let tempDirURL = NSTemporaryDirectory()
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: tempDirURL)
            print("contents: \(contents)")
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
