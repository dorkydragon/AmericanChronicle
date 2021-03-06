enum Month: Int {
    case january
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december

    var shortString: String {
        switch self {
        case .january:
            return "Jan"
        case .february:
            return "Feb"
        case .march:
            return "Mar"
        case .april:
            return "Apr"
        case .may:
            return "May"
        case .june:
            return "Jun"
        case .july:
            return "Jul"
        case .august:
            return "Aug"
        case .september:
            return "Sep"
        case .october:
            return "Oct"
        case .november:
            return "Nov"
        case .december:
            return "Dec"
        }
    }

    var longString: String {
        switch self {
        case .january:
            return "January"
        case .february:
            return "February"
        case .march:
            return "March"
        case .april:
            return "April"
        case .may:
            return "May"
        case .june:
            return "June"
        case .july:
            return "July"
        case .august:
            return "August"
        case .september:
            return "September"
        case .october:
            return "October"
        case .november:
            return "November"
        case .december:
            return "December"
        }
    }

    static func stringForRawValue(_ rawValue: Int) -> String {
        let month = Month(rawValue: rawValue) ?? .january
        return month.longString
    }
}
