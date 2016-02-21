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

    func beginWithSelectedDayMonthYear(dayMonthYear: DayMonthYear?)
}

class DatePickerPresenter: NSObject, DatePickerPresenterInterface {
    var wireframe: DatePickerWireframeInterface?
    var view: DatePickerViewInterface?
    var interactor: DatePickerInteractorInterface?

    func beginWithSelectedDayMonthYear(dayMonthYear: DayMonthYear?) {
        if let dayMonthYear = dayMonthYear {
            self.view?.selectedDayMonthYear = dayMonthYear
        }
    }

    func userDidSave(dayMonthYear: DayMonthYear) {
        wireframe?.userDidTapSave(dayMonthYear)
    }

    func userDidCancel() {
        wireframe?.userDidTapCancel()
    }
}