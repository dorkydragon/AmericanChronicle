extension String {
    func rangeFromNSRange(_ nsRange: NSRange) -> Range<String.Index>? {
        let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location)
        //let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
        let to16 = utf16.index(from16, offsetBy: nsRange.length)
        //let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
                return from ..< to
        }
        return nil
    }

    var description: String {
        return self
    }
}
