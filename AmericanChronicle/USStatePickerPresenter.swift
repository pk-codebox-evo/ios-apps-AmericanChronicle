//
//  USStatePickerPresenter.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 12/13/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import Foundation

protocol USStatePickerPresenterInterface: USStatePickerViewDelegate {

}

class USStatePickerPresenter: USStatePickerPresenterInterface {
    var interactor: USStatePickerInteractorInterface?
    var view: USStatePickerViewInterface?
    func begin() {
        interactor?.loadStateNames { names, error in
            if let names = names {
                self.view?.states = names
            }
        }
    }

    func userDidTapState(stateName: String) {

    }
}