// MARK: -
// MARK: DelayedSearchInterface protocol

protocol DelayedSearchInterface {
    var parameters: SearchParameters { get }
    init(parameters: SearchParameters,
         dataManager: SearchDataManagerInterface,
         runLoop: RunLoopInterface,
         completionHandler: ((SearchResults?, ErrorType?) -> ()))
    func cancel()
    func isSearchInProgress() -> Bool
}

// MARK: -
// MARK: DelayedSearch class

final class DelayedSearch: NSObject, DelayedSearchInterface {

    // MARK: Properties

    let parameters: SearchParameters
    private let dataManager: SearchDataManagerInterface
    private let completionHandler: (SearchResults?, ErrorType?) -> ()
    private var timer: NSTimer!

    // MARK: Init methods

    required init(parameters: SearchParameters,
                  dataManager: SearchDataManagerInterface,
                  runLoop: RunLoopInterface = NSRunLoop.currentRunLoop(),
                  completionHandler: ((SearchResults?, ErrorType?) -> ())) {
        self.parameters = parameters
        self.dataManager = dataManager
        self.completionHandler = completionHandler

        super.init()

        timer = NSTimer(timeInterval: 0.5,
                        target: self,
                        selector: #selector(timerDidFire(_:)),
                        userInfo: nil,
                        repeats: false)
        runLoop.addTimer(timer!, forMode: NSDefaultRunLoopMode)
    }

    // MARK: Internal methods

    func timerDidFire(sender: NSTimer) {
        dataManager.fetchMoreResults(parameters, completionHandler: completionHandler)
    }

    // MARK: DelayedSearchInterface methods

    func cancel() {
        if timer.valid { // Request hasn't started yet
            timer.invalidate()
            let error = NSError(domain: "", code: -999, userInfo: nil)
            completionHandler(nil, error)
        } else { // Request has started already.
            dataManager.cancelFetch(parameters) // Cancelling will trigger the completionHandler.
        }
    }

    /**
        Returns the correct value by the time the completion handler is called.
    */
    func isSearchInProgress() -> Bool {
        if timer.valid {
            return true
        }
        return dataManager.isFetchInProgress(parameters)
    }
}
