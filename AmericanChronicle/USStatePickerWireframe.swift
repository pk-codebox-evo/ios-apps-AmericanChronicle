//
//  USStatePickerWireframe.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 12/11/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import UIKit

// MARK: -
// MARK: USStatePickerWireframeInterface class

protocol USStatePickerWireframeInterface: class {
    func beginFromViewController(parentModuleViewController: UIViewController?)
}

// MARK: -
// MARK: USStatePickerWireframeDelegate class

protocol USStatePickerWireframeDelegate: class {
}

// MARK: -
// MARK: USStatePickerWireframe class

class USStatePickerWireframe: NSObject, USStatePickerWireframeInterface {

    let view: USStatePickerViewInterface
    let interactor: USStatePickerInteractorInterface
    let presenter: USStatePickerPresenterInterface

    internal init(
        view: USStatePickerViewInterface = USStatePickerViewController(),
        interactor: USStatePickerInteractorInterface = USStatePickerInteractor(),
        presenter: USStatePickerPresenterInterface = USStatePickerPresenter())
    {
        self.view = view
        self.interactor = interactor
        self.presenter = presenter

        super.init()

        self.view.delegate = self.presenter
    }

    func beginFromViewController(parentModuleViewController: UIViewController?) {
        if let vc = view as? USStatePickerViewController {
            parentModuleViewController?.presentViewController(vc, animated: true, completion: nil)
        }
    }
}
