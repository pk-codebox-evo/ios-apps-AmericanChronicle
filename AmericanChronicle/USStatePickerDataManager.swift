//
//  USStatePickerDataManager.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 12/13/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import Foundation

protocol USStatePickerDataManagerInterface {
    func loadStateNames(completionHandler: (([String]?, ErrorType?) -> Void))
}

class USStatePickerDataManager: USStatePickerDataManagerInterface {
    let service: USStatesServiceInterface

    init(service: USStatesServiceInterface = USStatesService()) {
        self.service = service
    }

    func loadStateNames(completionHandler: (([String]?, ErrorType?) -> Void)) {
        service.loadStateNames(completionHandler)
    }
}