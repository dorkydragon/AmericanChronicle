// http://scotthurff.com/posts/why-your-user-interface-is-awkward-youre-ignoring-the-ui-stack
enum SearchViewState: Equatable, CustomStringConvertible {
    case emptySearchField // Blank (A)
    case emptyResults // Blank (B)
    case loadingNewParamaters
    case loadingMoreRows
    case partial(title: String, rows: [SearchResultsRow])
    case ideal(title: String, rows: [SearchResultsRow])
    case error(title: String?, message: String?)

    var description: String {
        var desc = "<ViewState: "
        switch self {
        case .emptySearchField: desc += "EmptySearchField"
        case .emptyResults: desc += "EmptyResults"
        case .loadingNewParamaters: desc += "LoadingNewParamaters"
        case .loadingMoreRows: desc += "LoadingMoreRows"
        case let .partial(title, rows):
            desc += "Partial, title=\(title), rows=["
            desc += rows.map({"\($0.description)" }).joined(separator: ", ")
            desc += "]"
        case let .ideal(title, rows):
            desc += "Ideal, title=\(title), rows=["
            desc += rows.map({"\($0.description)" }).joined(separator: ", ")
            desc += "]"
        case let .error(title, message):
            desc += "Error, title=\(title), message=\(message)"
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
    case (let .partial(titleA, rowsA), let .partial(titleB, rowsB)):
        return (titleA == titleB) && (rowsA == rowsB)
    case (let .ideal(titleA, rowsA), let .ideal(titleB, rowsB)):
        return (titleA == titleB) && (rowsA == rowsB)
    case (let .error(titleA, messageA), let .error(titleB, messageB)):
        return (titleA == titleB) && (messageA == messageB)
    default: return false
    }
}
