//
//  OCRCoordinatesService.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 11/22/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import Alamofire

// MARK: -
// MARK: OCRCoordinatesServiceInterface

public protocol OCRCoordinatesServiceInterface {
    func startRequest(id: String, contextID: String, completionHandler: ((OCRCoordinates?, ErrorType?) -> Void))
    func isRequestInProgress(id: String, contextID: String) -> Bool
    func cancelRequest(id: String, contextID: String)
}

public class OCRCoordinatesService: OCRCoordinatesServiceInterface {

    private let manager: ManagerProtocol
    private var activeRequests: [String: RequestProtocol] = [:]
    private let queue = dispatch_queue_create("com.ryanipete.AmericanChronicle.OCRCoordinatesService", DISPATCH_QUEUE_SERIAL)

    public init(manager: ManagerProtocol = Manager()) {
        self.manager = manager
    }

    public func startRequest(id: String, contextID: String, completionHandler: ((OCRCoordinates?, ErrorType?) -> Void)) {
        if id.characters.count <= 0 {
            completionHandler(nil, NSError(code: .InvalidParameter, message: "Tried to fetch OCR info using an empty lccn."))
            return
        }

        if isRequestInProgress(id, contextID: contextID) {
            completionHandler(nil, NSError(code: .DuplicateRequest, message: "Message tried to send a duplicate request."))
            return
        }

        let URLString = URLStringForID(id)

        let request = self.manager.request(.GET, URLString: URLString, parameters: nil)?.responseObject(nil) { (response: Response<OCRCoordinates, NSError>) in
            dispatch_sync(self.queue) {
                self.activeRequests[URLString] = nil
            }
            completionHandler(response.result.value, response.result.error)
        }

        dispatch_sync(queue) {
            self.activeRequests[URLString] = request
        }
    }

    private func URLStringForID(id: String) -> String {
        return "\(ChroniclingAmericaEndpoint.baseURLString)\(id)coordinates"
    }

    public func isRequestInProgress(id: String, contextID: String) -> Bool {
        return activeRequests[URLStringForID(id)] != nil
    }

    public func cancelRequest(id: String, contextID: String) {

    }
}
