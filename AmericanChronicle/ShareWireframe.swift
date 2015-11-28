//
//  ShareWireframe.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 11/27/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import Foundation

public struct ShareWireframe {

    let presenter: SharePresenter
    let view: UIActivityViewController

    public init(image: UIImage) {
        self.view = UIActivityViewController(activityItems: [image], applicationActivities: [])

        self.presenter = SharePresenter()
        self.presenter.view = view
    }

    public func beginFromViewController(parentModuleViewController: UIViewController?) {
        parentModuleViewController?.presentViewController(view, animated: true, completion: nil)
    }
}