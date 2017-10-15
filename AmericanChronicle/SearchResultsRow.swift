struct SearchResultsRow: CustomStringConvertible {

    // MARK: Properties

    let id: String?
    let date: Date?
    let cityState: String
    let publicationTitle: String
    let thumbnailURL: URL?
    let pdfURL: URL?
    let lccn: String?
    let edition: Int?
    let sequence: Int?

    // MARK: Init methods

    init(id: String?,
         date: Date?,
         cityState: String,
         publicationTitle: String,
         thumbnailURL: URL?,
         pdfURL: URL?,
         lccn: String?,
         edition: Int?,
         sequence: Int?) {
        self.id = id
        self.date = date
        self.cityState = cityState
        self.publicationTitle = publicationTitle
        self.thumbnailURL = thumbnailURL
        self.pdfURL = pdfURL
        self.lccn = lccn
        self.edition = edition
        self.sequence = sequence
    }

    // MARK: CustomStringConvertible methods

    var description: String {
        var desc = "<SearchResultsRow: "
        desc += "id=\(id ?? "")"
        desc += ", date=\(String(describing: date))"
        desc += ", cityState=\(cityState)"
        desc += ", publicationTitle=\(publicationTitle)"
        desc += ", thumbnailURL=\(String(describing: thumbnailURL))"
        desc += ", lccn=\(String(describing: lccn))"
        desc += ", edition=\(String(describing: edition))"
        desc += ", sequence=\(String(describing: sequence))"
        desc += ">"
        return desc
    }
}

extension SearchResultsRow: Equatable { }
func == (lhs: SearchResultsRow, rhs: SearchResultsRow) -> Bool {
    return lhs.date == rhs.date
        && lhs.cityState == rhs.cityState
        && lhs.publicationTitle == rhs.publicationTitle
        && lhs.thumbnailURL == rhs.thumbnailURL
}
