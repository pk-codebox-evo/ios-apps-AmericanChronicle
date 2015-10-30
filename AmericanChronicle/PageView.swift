//
//  PageView.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/6/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

public protocol PageViewInterface: class {

    var pdfPage: CGPDFPageRef? { get set }
    var presenter: PagePresenterInterface? { get set }

    func showLoadingIndicator()
    func hideLoadingIndicator()
    func setDownloadProgress(progress: Float)
    func showErrorWithTitle(title: String?, message: String?)
}
