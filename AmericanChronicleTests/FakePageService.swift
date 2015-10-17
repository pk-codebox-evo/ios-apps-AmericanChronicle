//
//  FakePDFPageWebService.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 10/17/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import AmericanChronicle
import ObjectMapper

class FakeRequest: RequestProtocol {


    var task: NSURLSessionTask = NSURLSessionTask()


    private var responseObjectWasCalled_withCompletionHandler: Any?
    private var responseWasCalled_withCompletionHandler: ((NSURLRequest?, NSHTTPURLResponse?, NSData?, ErrorType?) -> Void)?

    func responseObject<T: Mappable>(completionHandler: ((T?, ErrorType?) -> Void)) -> Self {
        responseObjectWasCalled_withCompletionHandler = completionHandler
        return self
    }

    func response(completionHandler: (NSURLRequest?, NSHTTPURLResponse?, NSData?, ErrorType?) -> Void) -> Self {
        responseWasCalled_withCompletionHandler = completionHandler
        return self
    }

    func cancel() {}

    func finishWithResponseObject<T: Mappable>(responseObject: T?, error: ErrorType?) {
        let handler = responseObjectWasCalled_withCompletionHandler as! ((T?, ErrorType?) -> Void)
        handler(responseObject, error)
    }

    func finishWithRequest(request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) {
        responseWasCalled_withCompletionHandler?(request, response, data, error)
    }
}

class FakePageService: PageServiceInterface {

    var downloadPage_wasCalled_withURL: NSURL?
    var downloadPage_wasCalled_withCompletionHandler: ((NSURL?, ErrorType?) -> ())?
    func downloadPage(remoteURL: NSURL, contextID: String, completionHandler: (NSURL?, ErrorType?) -> Void) {
        downloadPage_wasCalled_withURL = remoteURL
        downloadPage_wasCalled_withCompletionHandler = completionHandler
    }

    var cancelDownload_wasCalled_withURL: NSURL?
    func cancelDownload(remoteURL: NSURL, contextID: String) {
        cancelDownload_wasCalled_withURL = remoteURL
    }

    var stubbed_isDownloadInProgress = false
    func isDownloadInProgress(remoteURL: NSURL) -> Bool {
        return stubbed_isDownloadInProgress
    }
}
