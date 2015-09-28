//
//  FakeSearchPresenter.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/12/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import AmericanChronicle

class FakeSearchPresenter: NSObject, SearchPresenterProtocol {

    var cancelCallback: ((Void) -> ())?
    var showPageCallback: ((SearchResultsRow) -> ())?
    var didCall_setUpView_withSearchView: SearchView?
    func setUpView(searchView: SearchView) {
        didCall_setUpView_withSearchView = searchView
    }
}
