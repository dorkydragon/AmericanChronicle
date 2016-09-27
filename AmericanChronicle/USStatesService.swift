protocol USStatesServiceInterface {
    func loadStateNames(_ completionHandler: (([String]?, Error?) -> Void))
}

final class USStatesService: USStatesServiceInterface {
    func loadStateNames(_ completionHandler: (([String]?, Error?) -> Void)) {
        let path = Bundle.main.path(forResource: "states", ofType: "json")
        if let path = path, let data = FileManager.default.contents(atPath: path) {
            do {
                let states = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String]
                completionHandler(states, nil)
            } catch let error {
                completionHandler(nil, error)
            }
        } else {
            let error = NSError(code: .missingBundleFile,
                                message: "Could not find 'states.json' file in bundle. Looking in path '\(path ?? "")'.")
            completionHandler(nil, error)
        }
    }
}
