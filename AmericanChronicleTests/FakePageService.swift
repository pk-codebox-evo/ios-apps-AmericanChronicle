@testable import AmericanChronicle
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class FakeRequest: RequestProtocol {

    var task: NSURLSessionTask = NSURLSessionTask()

    private var responseObjectWasCalled_withCompletionHandler: Any?
    private var responseWasCalled_withCompletionHandler: ((NSURLRequest?, NSHTTPURLResponse?, NSData?, ErrorType?) -> Void)?

    func responseObject<T: Mappable>(queue queue: dispatch_queue_t?,
                                      keyPath: String?,
                                      mapToObject object: T?,
                                      completionHandler: Alamofire.Response<T, NSError> -> Void) -> Self {
        responseObjectWasCalled_withCompletionHandler = completionHandler
        return self
    }

    func response(queue queue: dispatch_queue_t?, completionHandler: ((NSURLRequest?, NSHTTPURLResponse?, NSData?, NSError?) -> Void)) -> Self {
        return self
    }

    var cancel_wasCalled = false
    func cancel() {
        cancel_wasCalled = true
    }

    func finishWithResponseObject<T: Mappable>(responseObject: Response<T, NSError>) {
        let handler = responseObjectWasCalled_withCompletionHandler as? (Response<T, NSError> -> Void)
        handler?(responseObject)
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
