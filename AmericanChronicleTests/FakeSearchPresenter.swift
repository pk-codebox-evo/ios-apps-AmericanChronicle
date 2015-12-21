//
//  FakeSearchPresenter.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/12/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

@testable import AmericanChronicle

class FakeSearchPresenter: NSObject, SearchPresenterInterface {

    var wireframe: SearchWireframeInterface?
    var view: SearchViewInterface?
    var interactor: SearchInteractorInterface?

    func userDidTapCancel() {}
    func userDidTapReturn() {}
    func userDidTapUSStates() {}
    func userDidTapEarliestDateButton() {}
    func userDidTapLatestDateButton() {}
    func userDidChangeSearchToTerm(term: String?) {}
    func userIsApproachingLastRow(term: String?, inCollection: [SearchResultsRow]) {}
    func userDidSelectSearchResult(row: SearchResultsRow) {}
    func viewDidLoad() {}
    func userDidSaveFilteredUSStates(stateNames: [String]) {}
    func userDidNotSaveFilteredUSStates() {}
    func userDidSaveDate(date: NSDate) {}

    func search(parameters: SearchParameters, didFinishWithResults: SearchResults?, error: NSError?) {}
}
