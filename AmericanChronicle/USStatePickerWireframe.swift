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
    func beginFromViewController(parentModuleViewController: UIViewController?, selectedStateNames: [String])
    func userDidTapSave(selectedItems: [String])
    func userDidTapCancel()
    func finish()
}

// MARK: -
// MARK: USStatePickerWireframeDelegate class

protocol USStatePickerWireframeDelegate: class {
}

// MARK: -
// MARK: USStatePickerWireframe class

class USStatePickerWireframe: NSObject, USStatePickerWireframeInterface {

    let parentWireframe: SearchWireframeInterface
    let view: USStatePickerViewInterface
    let interactor: USStatePickerInteractorInterface
    let presenter: USStatePickerPresenterInterface

    internal init(
        parentWireframe: SearchWireframeInterface,
        view: USStatePickerViewInterface = USStatePickerViewController(),
        interactor: USStatePickerInteractorInterface = USStatePickerInteractor(),
        presenter: USStatePickerPresenterInterface = USStatePickerPresenter())
    {
        self.parentWireframe = parentWireframe
        self.view = view
        self.interactor = interactor
        self.presenter = presenter

        super.init()

        self.view.delegate = self.presenter
        self.presenter.view = self.view
        self.presenter.interactor = self.interactor
        self.presenter.wireframe = self
    }

    func beginFromViewController(parentModuleViewController: UIViewController?, selectedStateNames: [String]) {
        if let vc = view as? USStatePickerViewController {
            let nvc = UINavigationController(rootViewController: vc)
            nvc.modalPresentationStyle = .OverFullScreen
            nvc.modalTransitionStyle = .CrossDissolve
            parentModuleViewController?.presentViewController(nvc, animated: true, completion: nil)
            presenter.begin(selectedStateNames)
        }
    }

    func finish() {
        if let vc = view as? USStatePickerViewController, presenting = vc.presentingViewController {
            presenting.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func userDidTapSave(selectedItems: [String]) {
        parentWireframe.userDidSaveFilteredUSStates(selectedItems)
    }

    func userDidTapCancel() {
        parentWireframe.userDidNotSaveFilteredUSStates()
    }
}
