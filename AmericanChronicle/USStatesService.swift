//
//  USStatesService.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 12/11/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

protocol USStatesServiceInterface {
    func loadStateNames(completionHandler: (([String]?, ErrorType?) -> Void))
}

class USStatesService: USStatesServiceInterface {

    // MARK: Properties

    // MARK: Init methods

    init() {}

    func loadStateNames(completionHandler: (([String]?, ErrorType?) -> Void)) {
        let path = NSBundle.mainBundle().pathForResource("states", ofType: "json")
        if let path = path, data = NSFileManager.defaultManager().contentsAtPath(path) {
            do {
                let states = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? [String]
                completionHandler(states, nil)
            } catch let error {
                completionHandler(nil, error)
            }
        } else {
            completionHandler(nil, NSError(code: .MissingBundleFile, message: "Could not find 'states.json' file in bundle. Looking in path '\(path ?? "")'."))
        }
    }
}
