protocol USStatePickerInteractorInterface {
    func fetchStateNames(_ completion: (([String]?, Error?) -> Void))
}

struct USStatePickerInteractor: USStatePickerInteractorInterface {
    fileprivate let service: USStatesServiceInterface

    init(service: USStatesServiceInterface = USStatesService()) {
        self.service = service
    }

    func fetchStateNames(_ completion: (([String]?, Error?) -> Void)) {
        service.loadStateNames(completion)
    }
}
