//
//  DatePickerPresenter.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 12/20/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

protocol DatePickerPresenterInterface: DatePickerViewDelegate {
    var wireframe: DatePickerWireframeInterface? { get set }
    var view: DatePickerViewInterface? { get set }
    var interactor: DatePickerInteractorInterface? { get set }

    func begin(date: NSDate?)
}

class DatePickerPresenter: NSObject, DatePickerPresenterInterface {
    var wireframe: DatePickerWireframeInterface?
    var view: DatePickerViewInterface?
    var interactor: DatePickerInteractorInterface?

    func begin(date: NSDate?) {
        if let date = date {
            self.view?.selectedDate = date
        }
    }

    func userDidSave(date: NSDate) {
        wireframe?.userDidTapSave(date)
    }

    func userDidCancel() {
        wireframe?.userDidTapCancel()
    }
}