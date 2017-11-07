//
//  Request.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Alamofire
import SwiftyJSON

struct APIError {
    let id: Int
    let message: String
    let name: String
}

enum RequestError: Swift.Error {
    case noInternetConnection
    case noServerResponse
    case noJSONDataReceived
    case jsonParsingFailed
    case apiRequestError(error: APIError)
}

struct ResponseResult<T: Decodable> {
    let error: RequestError?
    let items: [T]?
    let total: Int?
    let nextPageRequestID: Int?
}

class StackExchangeRequest {
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
    
    private let apiDomain = "https://api.stackexchange.com/2.2/"
    private let site = "stackoverflow"
    private var headers: HTTPHeaders = ["Accept": "application/json", "Accept-Encoding": "gzip"]
    private let key = "" // Stack Exchange API key should be here
    private let httpErrorCode = 400
    var filterName = "!7tRY9Gt*TsstT6tu0AvgTO.bfTAJIkb9J3"
    
    init(filter: String? = nil) {
        if let filterName = filter {
            self.filterName = filterName
        }
    }
    
    func vectorize(parameters: [Int]) -> String {
        return parameters.map({ String($0) }).joined(separator: ";")
    }
    
    func vectorize(parameters: [String]) -> String {
        return parameters.joined(separator: ";")
    }
    
    private func buildParameters(from options: [ParametersConvertible]) -> Parameters {
        var parameters: Parameters = [:]
        
        for option in options {
            parameters.merge(option.parameters, uniquingKeysWith:{ current, _ in current })
        }
        
        return parameters
    }
    
    @discardableResult
    func makeRequest<T: Decodable>(to endpoint: String,
                                   with options: [ParametersConvertible] = [],
                                   method: HTTPMethod = .get,
                                   ignoreResult: Bool = false,
                                   noSite: Bool = false,
                                   completion: @escaping (T?, RequestError?, Bool?) -> Void) -> Request
    {
        var requestParameters = buildParameters(from: options)
        
        if !noSite {
            requestParameters["site"] = self.site
        }
        
        requestParameters["key"] = self.key
        requestParameters["filter"] = self.filterName
        
        if let accessToken = AuthenticatedUser.current.accessToken {
            requestParameters["access_token"] = accessToken
        }
        
        return Alamofire.request(self.apiDomain + endpoint, method: method, parameters: requestParameters, headers: self.headers).validate().responseJSON { responseInfo in
            if let code = (responseInfo.error as? URLError)?.errorCode, code == NSURLErrorNotConnectedToInternet {
                completion(nil, RequestError.noInternetConnection, nil)
                return
            }
            
            guard let response = responseInfo.response else {
                completion(nil, RequestError.noServerResponse, nil)
                return
            }
            
            guard let jsonData = responseInfo.data else {
                completion(nil, RequestError.noJSONDataReceived, nil)
                return
            }
            
            guard let responseWrapper = try? self.jsonDecoder.decode(ResponseWrapper.self, from: jsonData) else {
                completion(nil, RequestError.jsonParsingFailed, nil)
                return
            }
            
            guard response.statusCode != self.httpErrorCode else {
                let apiError = APIError(id: responseWrapper.errorID ?? -1, message: responseWrapper.errorMessage ?? "", name: responseWrapper.errorName ?? "Unknown")
                completion(nil, RequestError.apiRequestError(error: apiError), nil)
                return
            }
            
            do {
                if !ignoreResult {
                    let itemsData = try JSON(jsonData)["items"].rawData()
                    let result = try self.jsonDecoder.decode(T.self, from: itemsData)
                    completion(result, nil, responseWrapper.hasMore)
                } else {
                    completion(nil, nil, responseWrapper.hasMore)
                }
            } catch {
                completion(nil, RequestError.jsonParsingFailed, nil)
            }
        }
    }
}
