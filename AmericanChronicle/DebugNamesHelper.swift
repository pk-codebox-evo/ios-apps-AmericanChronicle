class DebugNamesHelper {
    
    init() {
    }
    
    func namesRequest(accountType: String) -> NSMutableURLRequest {
        let headers = [
            "authorization": "StitchFixInternal key=15539b9f-b271-4b8b-a6ed-b25d3eaf4219",
            "content-type": "application/json; version=1",
            "accept": "application/json; version=1",
        ]
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://thenames.herokuapp.com/api/account?account_type=\(accountType)")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 20.0)
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        return request
    }
    
    func generateTestAccount(type: AccountType) -> JSONPromise {
        
        let request = namesRequest(type.rawValue)
        let promise = JSONPromise() { fulfill, reject in

        HTTPClient.manager.request(request)
            .responseJSON { responseObject in
                switch responseObject.result {
                case .Failure(let error):
                    reject(error)
                case .Success(let value):
                    if let json = value as? [String: AnyObject], statusCode = responseObject.response?.statusCode {
                        switch statusCode {
                        case 200..<300: fulfill(json)
                        default:        reject(NSError.fromJson(json))
                        }
                    } else {
                        reject(NSError.unknownError())
                    }
                }
            }
        }
        
        return promise
    }
    
    func createAndLoginNamesUser(type: AccountType) -> EmptyPromise {
        let promise = EmptyPromise() { fulfill, reject in
            generateTestAccount(type).then { json -> Void in
                if let username = json["user"]?["username"] as? String {
                    AuthenticationService().signIn(username: username, password: "supersecret")
                        .then { customer -> Void in
                            fulfill()
                        }.error { error in
                            reject(error)
                    }
                } else {
                    reject(NSError.unknownError())
                }
                }.error { error in
                    reject(error)
            }
        }
        
        return promise
    }
    
    enum AccountType : String {
        case Onboarding         = "1"
        case Scheduled          = "2"
        case Checkout           = "3"
        case Scheduling         = "4"
        case StylingOrPacked    = "5"
        case InTransit          = "6"
        case FixDelayed         = "7"
        case TruantOrFraud      = "8"
        case Referrals          = "9"
        
        var name : String {
            switch self {
            case .Onboarding:       return "onboarding"
            case .Scheduled:        return "scheduled"
            case .Checkout:         return "checkout"
            case .Scheduling:       return "scheduling"
            case .StylingOrPacked:  return "styling_or_packed"
            case .InTransit:        return "in_transit"
            case .FixDelayed:       return "fix_delayed"
            case .TruantOrFraud:    return "truant_or_fraud"
            case .Referrals:        return "referrals"
            }
        }
    }
}
