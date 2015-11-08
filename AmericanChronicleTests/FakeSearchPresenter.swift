//
//  FakeSearchPresenter.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/12/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import AmericanChronicle

class FakeSearchPresenter: NSObject, SearchPresenterInterface {
    var wireframe: SearchWireframeInterface?
    var view: SearchViewInterface?
    var interactor: SearchInteractorInterface?

    func userDidTapCancel() {}

    func userDidChangeSearchToTerm(term: String?) {}

    func userIsApproachingLastRow(term: String?, inCollection: [SearchResultsRow]) {}

    func userDidSelectSearchResult(row: SearchResultsRow) {}

    func searchForTerm(term: String, existingRows: [SearchResultsRow], didFinishWithResults: SearchResults?, error: NSError?) {}
}
