// http://scotthurff.com/posts/why-your-user-interface-is-awkward-youre-ignoring-the-ui-stack
enum SearchViewState: Equatable, CustomStringConvertible {
    case emptySearchField // Blank (A)
    case emptyResults // Blank (B)
    case loadingNewParamaters
    case loadingMoreRows
    case partial(totalCount: Int, rows: [SearchResultsRow])
    case ideal(totalCount: Int, rows: [SearchResultsRow])
    case error(title: String?, message: String?)

    var description: String {
        var desc = "<ViewState: "
        switch self {
        case .emptySearchField: desc += "EmptySearchField"
        case .emptyResults: desc += "EmptyResults"
        case .loadingNewParamaters: desc += "LoadingNewParamaters"
        case .loadingMoreRows: desc += "LoadingMoreRows"
        case let .partial(totalCount, rows):
            desc += "Partial, totalCount=\(totalCount), rows=["
            desc += rows.map({"\($0.description)" }).joined(separator: ", ")
            desc += "]"
        case let .ideal(totalCount, rows):
            desc += "Ideal, totalCount=\(totalCount), rows=["
            desc += rows.map({"\($0.description)" }).joined(separator: ", ")
            desc += "]"
        case let .error(title, message):
            desc += "Error, title=\(title ?? ""), message=\(message ?? "")"
        }
        desc += ">"
        return desc
    }
}

func == (viewA: SearchViewState, viewB: SearchViewState) -> Bool {
    switch (viewA, viewB) {
    case (.emptySearchField, .emptySearchField): return true
    case (.emptyResults, .emptyResults): return true
    case (.loadingNewParamaters, .loadingNewParamaters): return true
    case (.loadingMoreRows, .loadingMoreRows): return true
    case (let .partial(totalCountA, rowsA), let .partial(totalCountB, rowsB)):
        return (totalCountA == totalCountB) && (rowsA == rowsB)
    case (let .ideal(totalCountA, rowsA), let .ideal(totalCountB, rowsB)):
        return (totalCountA == totalCountB) && (rowsA == rowsB)
    case (let .error(totalCountA, messageA), let .error(totalCountB, messageB)):
        return (totalCountA == totalCountB) && (messageA == messageB)
    default: return false
    }
}
