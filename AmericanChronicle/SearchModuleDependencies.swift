//
//  SearchModuleDependencies.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/17/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

public final class SearchModuleDependencies {
    let dataManager: SearchDataManagerInterface
    let interactor: SearchInteractorInterface
    lazy var view: SearchViewInterface? = {
        let sb = UIStoryboard(name: "Search", bundle: nil)
        return sb.instantiateInitialViewController() as? SearchViewController
    }()

    lazy var presenter: SearchPresenterInterface = SearchPresenter()



    init() {
        dataManager = SearchDataManager()
        let searchFactory = DelayedSearchFactory(dataManager: dataManager)
        interactor = SearchInteractor(searchFactory: searchFactory)
        view?.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.delegate = presenter
    }
}
