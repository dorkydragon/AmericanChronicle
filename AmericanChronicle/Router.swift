import Alamofire

enum Router: URLRequestConvertible {
    case pagesSearch(params: SearchParameters, page: Int)
    case ocrCoordinates(pageID: String)

    static let baseURLString = "http://chroniclingamerica.loc.gov"

    func asURLRequest() throws -> URLRequest {
        switch self {
        case .pagesSearch(let params, let page):
            let path = "search/pages/results"
            let earliestMonth = "\(params.earliestDayMonthYear.month)"
            let earliestDay = "\(params.earliestDayMonthYear.day)"
            let earliestYear = "\(params.earliestDayMonthYear.year)"
            let date1 = "\(earliestMonth)/\(earliestDay)/\(earliestYear)"

            let latestMonth = "\(params.latestDayMonthYear.month)"
            let latestDay = "\(params.latestDayMonthYear.day)"
            let latestYear = "\(params.latestDayMonthYear.year)"
            let date2 = "\(latestMonth)/\(latestDay)/\(latestYear)"

            let term = params.term.replacingOccurrences(of: " ", with: "+")

            let paramsDict: Parameters = [
                "format": "json",
                "rows": 20,
                "page": page,
                "dateFilterType": "range",
                "date1": date1,
                "date2": date2,
                "proxtext": term
            ]

            var urlString = Router.baseURLString
            urlString = urlString.appending("/\(path)")

            // There's no good way to pass the states as parameters, so construct
            // the entire url by hand.

            if !params.states.isEmpty {
                let statesString = params.states.map { state in
                    return "state=\(state.replacingOccurrences(of: " ", with: "+"))"
                }.joined(separator: "&")
                urlString = urlString.appending("?\(statesString)&")
            } else {
                urlString = urlString.appending("?")
            }

            let paramsStrings = paramsDict.map { key, value in
                return "\(key)=\(value)"
            }
            urlString = urlString.appending(paramsStrings.joined(separator: "&"))
            let url = try urlString.asURL()
            return URLRequest(url: url)
        case .ocrCoordinates(let pageID):
            let url = try Router.baseURLString.asURL()
            let path = "\(pageID)coordinates"
            let urlRequest = URLRequest(url: url.appendingPathComponent(path))

            return try URLEncoding.default.encode(urlRequest, with: nil)
        }

    }
}
