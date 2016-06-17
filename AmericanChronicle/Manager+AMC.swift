import Alamofire

protocol ManagerProtocol {
    func request(
        method: Alamofire.Method,
        URLString: URLStringConvertible,
        parameters: [String: AnyObject]?) -> RequestProtocol?
    func download(
        method: Alamofire.Method,
        URLString: URLStringConvertible,
        parameters: [String: AnyObject]?,
        destination: Request.DownloadFileDestination) -> RequestProtocol?
}

extension Manager: ManagerProtocol {
    func request(
        method: Alamofire.Method,
        URLString: URLStringConvertible,
        parameters: [String: AnyObject]?) -> RequestProtocol? {
            return request(method, URLString, parameters: parameters, encoding: .URL, headers: nil)
    }

    func download(
        method: Alamofire.Method,
        URLString: URLStringConvertible,
        parameters: [String: AnyObject]?,
        destination: Request.DownloadFileDestination) -> RequestProtocol? {
            return download(method,
                            URLString,
                            parameters: parameters,
                            encoding: .URL,
                            headers: nil,
                            destination: destination)
    }
}
