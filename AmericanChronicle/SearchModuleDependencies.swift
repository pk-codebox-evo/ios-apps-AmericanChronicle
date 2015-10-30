//
//  SearchModuleDependencies.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/17/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

public final class SearchModuleDependencies {
    lazy var view: SearchViewInterface? = {
        let sb = UIStoryboard(name: "Search", bundle: nil)
        return sb.instantiateInitialViewController() as? SearchViewController
    }()

    lazy var presenter: SearchPresenterInterface = SearchPresenter()
    lazy var interactor: SearchInteractorInterface = SearchInteractor()
    lazy var dataManager: SearchDataManagerInterface = SearchDataManager()

    init() {
        view?.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.dataManager = dataManager
        interactor.delegate = presenter
    }
}
