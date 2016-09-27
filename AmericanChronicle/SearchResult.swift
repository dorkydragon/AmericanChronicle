import ObjectMapper

final class SearchResult: NSObject, Mappable {

    // mark: Properties

    var sequence: Int?
    var county: [String]?
    var edition: Int?
    var frequency: String?
    var id: String?
    var subject: [String]?
    var city: [String]?
    var date: Date?
    var title: String?
    var endYear: Int?
    var note: [String]?
    var state: [String]?
    var sectionLabel: String?
    var type: String?
    var placeOfPublication: String?
    var startYear: Int?
    var editionLabel: String?
    var publisher: String?
    var language: [String]?
    var altTitle: [String]?
    var lccn: String?
    var country: String?
    var ocrEng: String?
    var batch: String?
    var titleNormal: String?
    var url: String?
    var place: [String]?
    var page: String?
    var thumbnailURL: URL?
    var pdfURL: URL?
    var estimatedPDFSize: Int {
        return (ocrEng?.characters.count ?? 0) * 30
    }

    // mark: Init methods

    static func newInstance(_ map: Map) -> Mappable? {
        return SearchResult(map: map)
    }

    override init() {
        super.init()
    }

    required init?(map: Map) {
        super.init()
    }

    // mark: Mapping methods

    func mapping(map: Map) {
        sequence <- map["sequence"]
        county <- map["county"]
        edition <- map["edition"]
        frequency <- map["frequency"]
        id <- map["id"]
        subject <- map["subject"]
        city <- map["city"]

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let dateTransform = TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
            return formatter.date(from: value ?? "")
            }, toJSON: { (value: Date?) -> String? in
                if let date = value {
                    return formatter.string(from: date)
                }
                return nil
        })

        date <- (map["date"], dateTransform)
        title <- map["title"]
        endYear <- map["end_year"]
        note <- map["note"]
        state <- map["state"]
        sectionLabel <- map["section_label"]
        type <- map["type"]
        placeOfPublication <- map["place_of_publication"]
        startYear <- map["start_year"]
        editionLabel <- map["edition_label"]
        publisher <- map["publisher"]
        language <- map["language"]
        altTitle <- map["alt_title"]
        lccn <- map["lccn"]
        country <- map["country"]
        ocrEng <- map["ocr_eng"]
        batch <- map["batch"]
        titleNormal <- map["title_normal"]
        url <- map["url"]
        place <- map["place"]
        page <- map["page"]
        thumbnailURL = URL(string: url ?? "")?.deletingPathExtension().appendingPathComponent("thumbnail.jpg")
        pdfURL = URL(string: url ?? "")?.deletingPathExtension().appendingPathExtension("pdf")
    }

    // mark: NSObject overrides

    override var description: String {
        let empty = ""
        var str = "<\(type(of: self)) \(Unmanaged.passUnretained(self).toOpaque()):"
        str += " sequence=\(sequence?.description ?? empty)"
        str += ", county=\(county?.description ?? empty)"
        str += ", edition=\(edition?.description ?? empty)"
        str += ", frequency=\(frequency?.description ?? empty)"
        str += ", id=\(id?.description ?? empty)"
        str += ", subject=\(subject?.description ?? empty)"
        str += ", city=\(city?.description ?? empty)"
        str += ", date=\(date?.description ?? empty)"
        str += ", title=\(title?.description ?? empty)"
        str += ", endYear=\(endYear?.description ?? empty)"
        str += ", note=\(note?.description ?? empty)"
        str += ", state=\(state?.description ?? empty)"
        str += ", sectionLabel=\(sectionLabel?.description ?? empty)"
        str += ", type=\(type?.description ?? empty)"
        str += ", placeOfPublication=\(placeOfPublication?.description ?? empty)"
        str += ", startYear=\(startYear?.description ?? empty)"
        str += ", editionLabel=\(editionLabel?.description ?? empty)"
        str += ", publisher=\(publisher?.description ?? empty)"
        str += ", language=\(language?.description ?? empty)"
        str += ", altTitle=\(altTitle?.description ?? empty)"
        str += ", lccn=\(lccn?.description ?? empty)"
        str += ", country=\(country?.description ?? empty)"
        str += ", count(ocrEng)=\((ocrEng ?? empty).characters.count.description)"
        str += ", batch=\(batch?.description ?? empty)"
        str += ", titleNormal=\(titleNormal?.description ?? empty)"
        str += ", url=\(url?.description ?? empty)"
        str += ", place=\(place?.description ?? empty)"
        str += ", page=\(page?.description ?? nil)"
        str += ", thumbnailURL=\(thumbnailURL?.absoluteString ?? empty)"
        str += ", pdfURL=\(pdfURL?.absoluteString ?? empty)"
        str += ">"
        return str
    }
}
