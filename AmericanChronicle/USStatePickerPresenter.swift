//
//  USStatePickerPresenter.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 12/13/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import Foundation

protocol USStatePickerPresenterInterface: USStatePickerViewDelegate {
    var wireframe: USStatePickerWireframeInterface? { get set }
    var view: USStatePickerViewInterface? { get set }
    var interactor: USStatePickerInteractorInterface? { get set }

    func begin(selectedStateNames: [String])
}

class USStatePickerPresenter: USStatePickerPresenterInterface {

    var wireframe: USStatePickerWireframeInterface?
    var view: USStatePickerViewInterface?
    var interactor: USStatePickerInteractorInterface?

    func begin(selectedStateNames: [String]) {
        interactor?.loadStateNames { names, error in
            if let names = names {
                self.view?.states = names
                self.view?.setSelectedStateNames(selectedStateNames)
            }
        }
    }

    func userDidTapSave(selectedStateNames: [String]) {
        self.wireframe?.userDidTapSave(selectedStateNames)
    }

    func userDidTapCancel() {
        self.wireframe?.userDidTapCancel()
    }
}