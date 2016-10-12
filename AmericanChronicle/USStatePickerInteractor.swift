protocol USStatePickerInteractorInterface {
    func loadStateNames(_ completionHandler: (([String]?, Error?) -> Void))
}

final class USStatePickerInteractor: NSObject, USStatePickerInteractorInterface {
    fileprivate let service: USStatesServiceInterface

    init(service: USStatesServiceInterface = USStatesService()) {
        self.service = service
    }

    func loadStateNames(_ completionHandler: (([String]?, Error?) -> Void)) {
        service.loadStateNames(completionHandler)
    }
}
