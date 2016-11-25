import ObjectMapper
fileprivate func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


final class SearchResults: NSObject, Mappable {

    // MARK: Properties

    var totalItems: Int?
    var endIndex: Int?
    var startIndex: Int?
    var itemsPerPage: Int = 20
    var items: [SearchResult]?
    var allItemsLoaded: Bool {
        return items?.count >= totalItems
    }
    var numLoadedPages: Int {
        return Int(ceilf(Float(items?.count ?? 0)/Float(itemsPerPage)))
    }

    // MARK: Init methods

    static func newInstance(_ map: Map) -> Mappable? {
        return SearchResults(map: map)
    }

    override init() {
        super.init()
    }

    required init?(map: Map) {
        super.init()
    }

    // MARK: Mappable methods

    func mapping(map: Map) {
        totalItems <- map["totalItems"]
        endIndex <- map["endIndex"]
        startIndex <- map["startIndex"]
        itemsPerPage <- map["itemsPerPage"]
        items <- map["items"]
    }

    // MARK: NSObject overrides

    override var description: String {
        let empty = "(nil)"
        var str = "<\(type(of: self)) \(Unmanaged.passUnretained(self).toOpaque()):"
        str += " totalItems=\(totalItems?.description ?? empty)"
        str += ", endIndex=\(endIndex?.description ?? empty)"
        str += ", startIndex=\(startIndex?.description ?? empty)"
        str += ", itemsPerPage=\(itemsPerPage.description)"
        str += ", items.count=\(items?.count ?? 0)"
        str += ">"
        return str
    }
}
