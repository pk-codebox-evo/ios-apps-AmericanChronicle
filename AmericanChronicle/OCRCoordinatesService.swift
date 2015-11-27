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
    func startRequest(
            lccn: String,
            date: NSDate,
            edition: Int,
            sequence: Int,
            contextID: String,
            completionHandler: ((OCRCoordinates?, ErrorType?) -> Void))
    func isRequestInProgress(
            lccn: String,
            date: NSDate,
            edition: Int,
            sequence: Int,
            contextID: String) -> Bool
    func cancelRequest(
            lccn: String,
            date: NSDate,
            edition: Int,
            sequence: Int,
            contextID: String)
}

public class OCRCoordinatesService: OCRCoordinatesServiceInterface {

    private let manager: ManagerProtocol
    private var activeRequests: [String: RequestProtocol] = [:]
    private let queue = dispatch_queue_create("com.ryanipete.AmericanChronicle.OCRCoordinatesService", DISPATCH_QUEUE_SERIAL)

    public init(manager: ManagerProtocol = Manager()) {
        self.manager = manager
    }

    public func startRequest(
            lccn: String,
            date: NSDate,
            edition: Int,
            sequence: Int,
            contextID: String,
            completionHandler: ((OCRCoordinates?, ErrorType?) -> Void))
    {
        if lccn.characters.count <= 0 {
            completionHandler(nil, NSError(code: .InvalidParameter, message: "Tried to fetch OCR info using an empty lccn."))
            return
        }

        if isRequestInProgress(lccn, date: date, edition: edition, sequence: sequence, contextID: contextID) {
            completionHandler(nil, NSError(code: .DuplicateRequest, message: "Message tried to send a duplicate request."))
            return
        }


        let URLString = URLStringForLCCN(lccn, date: date, edition: edition, sequence: sequence)

        let request = self.manager.request(.GET, URLString: URLString, parameters: nil)?.responseObject { (obj: OCRCoordinates?, error) in
            dispatch_sync(self.queue) {
                self.activeRequests[URLString] = nil
            }
            completionHandler(obj, error)
        }

        dispatch_sync(queue) {
            self.activeRequests[URLString] = request
        }
    }

    private func URLStringForLCCN(lccn: String, date: NSDate, edition: Int, sequence: Int) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.stringFromDate(date)
        return "lccn/\(lccn)/\(dateString)/ed-\(edition)/seq-\(sequence)/coordinates/"
    }

    public func isRequestInProgress(
            lccn: String,
            date: NSDate,
            edition: Int,
            sequence: Int,
            contextID: String) -> Bool
    {
        return activeRequests[URLStringForLCCN(lccn, date: date, edition: edition, sequence: sequence)] != nil
    }

    public func cancelRequest(
            lccn: String,
            date: NSDate,
            edition: Int,
            sequence: Int,
            contextID: String)
    {

    }
}
