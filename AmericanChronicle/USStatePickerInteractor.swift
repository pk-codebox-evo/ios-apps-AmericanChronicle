//
//  USStatePickerInteractor.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 12/9/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

protocol USStatePickerInteractorInterface {
    func loadStateNames(completionHandler: (([String]?, ErrorType?) -> Void))
}

class USStatePickerInteractor: NSObject, USStatePickerInteractorInterface {
    let dataManager: USStatePickerDataManagerInterface
    init(dataManager: USStatePickerDataManagerInterface = USStatePickerDataManager()) {
        self.dataManager = dataManager
    }

    func loadStateNames(completionHandler: (([String]?, ErrorType?) -> Void)) {
        dataManager.loadStateNames(completionHandler)
    }
}