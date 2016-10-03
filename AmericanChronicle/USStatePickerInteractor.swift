protocol USStatePickerInteractorInterface {
    func loadStateNames(_ completionHandler: (([String]?, Error?) -> Void))
}

final class USStatePickerInteractor: NSObject, USStatePickerInteractorInterface {
    fileprivate let dataManager: USStatePickerDataManagerInterface

    init(dataManager: USStatePickerDataManagerInterface = USStatePickerDataManager()) {
        self.dataManager = dataManager
    }

    func loadStateNames(_ completionHandler: (([String]?, Error?) -> Void)) {
        dataManager.loadStateNames(completionHandler)
    }
}
