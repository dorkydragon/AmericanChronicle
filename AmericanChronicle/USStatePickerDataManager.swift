protocol USStatePickerDataManagerInterface {
    func loadStateNames(_ completionHandler: (([String]?, Error?) -> Void))
}

final class USStatePickerDataManager: USStatePickerDataManagerInterface {
    fileprivate let service: USStatesServiceInterface

    init(service: USStatesServiceInterface = USStatesService()) {
        self.service = service
    }

    func loadStateNames(_ completionHandler: (([String]?, Error?) -> Void)) {
        service.loadStateNames(completionHandler)
    }
}
