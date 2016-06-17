protocol USStatesServiceInterface {
    func loadStateNames(completionHandler: (([String]?, ErrorType?) -> Void))
}

final class USStatesService: USStatesServiceInterface {
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
            let error = NSError(code: .MissingBundleFile,
                                message: "Could not find 'states.json' file in bundle. Looking in path '\(path ?? "")'.")
            completionHandler(nil, error)
        }
    }
}
