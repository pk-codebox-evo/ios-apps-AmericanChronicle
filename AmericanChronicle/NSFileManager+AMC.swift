extension NSFileManager {
    class var defaultDocumentDirectoryURL: NSURL? {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory,
                                                               inDomains: .UserDomainMask).first
    }

    class var defaultApplicationDirectoryURL: NSURL? {
        return NSFileManager.defaultManager().URLsForDirectory(.ApplicationDirectory,
                                                               inDomains: .UserDomainMask).first
    }

    class var defaultLibraryDirectoryURL: NSURL? {
        return NSFileManager.defaultManager().URLsForDirectory(.LibraryDirectory,
                                                               inDomains: .UserDomainMask).first
    }

    class var defaultCachesDirectoryURL: NSURL? {
        return NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory,
                                                               inDomains: .UserDomainMask).first
    }

    class var defaultDownloadsDirectoryURL: NSURL? {
        return NSFileManager.defaultManager().URLsForDirectory(.DownloadsDirectory,
                                                               inDomains: .UserDomainMask).first
    }

    class var defaultItemReplacementDirectoryURL: NSURL? {
        return NSFileManager.defaultManager().URLsForDirectory(.ItemReplacementDirectory,
                                                               inDomains: .UserDomainMask).first
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
            let contents = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(tempDirURL)
            print("contents: \(contents)")
            return contents
        } catch let error {
            print("error: \(error)")
        }
        return []
    }

    class func fullURLForTemporaryFileWithName(name: String) -> NSURL? {
        let tempDirURL = NSURL(fileURLWithPath: NSTemporaryDirectory())
        let fullURL = tempDirURL.URLByAppendingPathComponent(name)
        return fullURL
    }

    class func attributesForTemporaryFileWithName(name: String) -> [String: AnyObject] {
        let fullURL = fullURLForTemporaryFileWithName(name)
        if let fullURLString = fullURL?.absoluteString {
            do {
                let attributes = try NSFileManager.defaultManager()
                                        .attributesOfItemAtPath(fullURLString)
                return attributes
            } catch let error {
                print("error: \(error)")
            }
        }
        return [:]
    }
}
