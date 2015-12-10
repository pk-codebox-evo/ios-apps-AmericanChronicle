//
//  SearchFiltersPresenter.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 12/9/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

protocol SearchFiltersPresenterInterface {
    var wireframe: SearchFiltersWireframeInterface? { get set }
}

class SearchFiltersPresenter: SearchFiltersPresenterInterface {
    var wireframe: SearchFiltersWireframeInterface?


    func userDidTapEarliestDate() {
        wireframe?.earliestDateButtonTapped(sender)
    }

    func userDidTapLatestDate() {
        wireframe?.latestDateButtonTapped(sender)
    }

    func userDidTapAddLocation() {
        wireframe?.addLocationButtonTapped(sender)
    }
}
