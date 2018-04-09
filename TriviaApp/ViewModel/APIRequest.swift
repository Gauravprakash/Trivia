//
//  APIRequest.swift
//  Quizzler
//
//  Created by Gaurav Prakash on 21/03/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire

private func JSONResponseDataFormatter(_ data: Data) -> Data {
     do{
        let dataAsJSON =  try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
      }
     catch{
        return data
        }
}
let configuration = { () -> URLSessionConfiguration in
    let config = URLSessionConfiguration.default
    config.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
    config.httpShouldSetCookies = false
    config.urlCache = nil
    config.timeoutIntervalForRequest = 200
    config.timeoutIntervalForResource = 400
    config.requestCachePolicy = .useProtocolCachePolicy
    return config
}()

let manager = Manager(
    configuration: configuration,
    serverTrustPolicyManager: ServicePolicyManager()
)

private extension String{
    var urlEscaped:String{
    return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

let APIProvider = MoyaProvider<Quizzler>(manager: manager,plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

public enum Quizzler {
    case CATEGORY
    case OPENDB([String: Any])
}

extension Quizzler:TargetType{
    public var baseURL: URL {
         return URL(string: "https://opentdb.com")!
        }
    
    var parameterEncoding: ParameterEncoding{
        return URLEncoding.queryString
    }
    
    public var path: String {
        switch self {
        case .CATEGORY:
            return "api_category.php"
        case .OPENDB:
            return "api.php"
        }
    }
    
    public var method: Moya.Method{
        return .get
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch  self{
        case .OPENDB(let params):
            return .requestParameters(parameters: params, encoding: parameterEncoding)
        case .CATEGORY:
            return .requestPlain
    }

    }
    
    public var validate:Bool{
        switch self {
        default:
            return false
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    
}

class ServicePolicyManager: ServerTrustPolicyManager{
    override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        return .disableEvaluation
    }
    
    public init() {
        super.init(policies: [:])
    }
}



