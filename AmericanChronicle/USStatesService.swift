protocol USStatesServiceInterface {
    func loadStateNames(_ completion: (([String]?, Error?) -> Void))
}

struct USStatesService: USStatesServiceInterface {
    func loadStateNames(_ completion: (([String]?, Error?) -> Void)) {
        let path = Bundle.main.path(forResource: "states", ofType: "json")
        if let path = path, let data = FileManager.default.contents(atPath: path) {
            do {
                let states = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String]
                completion(states, nil)
            } catch let error {
                completion(nil, error)
            }
        } else {
            // "Could not find 'states.json' file in bundle. Looking in path
            let localizedMsg = NSLocalizedString("states.json missing", comment: "states.json missing")
            let error = NSError(code: .missingBundleFile,
                                message: "\(localizedMsg) '\(path ?? "")'.")
            completion(nil, error)
        }
    }
}
