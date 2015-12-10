//
//  SearchFiltersWireframe.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 12/9/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import UIKit

protocol SearchFiltersWireframeInterface: class {
    func beginFromViewController(parentModuleViewController: UIViewController?)
    func userDidTapEarliestDate()
    func userDidTapLatestDate()
    func userDidTapAddLocation()
}

protocol SearchFiltersWireframeDelegate: class {
    func userDidTapCancel()
}

// MARK: -
// MARK: SearchWireframe class

class SearchFiltersWireframe: NSObject, SearchFiltersWireframeInterface {

    let view: SearchFiltersViewInterface

    init(view: SearchFiltersViewInterface) {
        self.view = view
        super.init()
    }

    func beginFromViewController(parentModuleViewController: UIViewController?) {
        if let vc = view as? SearchFiltersViewController {
            let nvc = UINavigationController(rootViewController: vc)
            parentModuleViewController?.presentViewController(nvc, animated: true, completion: nil)
        }
    }

    func userDidTapEarliestDate() {
    }

    func userDidTapLatestDate() {
    }

    func userDidTapAddLocation() {
    }
}
