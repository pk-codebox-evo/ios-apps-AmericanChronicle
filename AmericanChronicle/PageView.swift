//
//  PageView.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/6/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

public protocol PageView: class {
    var doneCallback: ((Void) -> ())? { get set }
    var shareCallback: ((Void) -> ())? { get set }
    var cancelCallback: ((Void) -> ())? { get set }
    var pdfPage: CGPDFPageRef? { get set }

    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showErrorWithTitle(title: String?, message: String?)
}
