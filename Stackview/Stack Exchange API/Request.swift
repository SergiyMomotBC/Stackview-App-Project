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
    private let key = "GzRntkcuVDbKd0rmPMCdUA(("
    private let httpErrorCode = 400
    private let filterName = "!*MGgi9snja3dZ(_b"
    
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
    
    func makeRequest<T: Decodable>(to endpoint: String, with options: [ParametersConvertible] = [], requiresAccessToken: Bool = false, completion: @escaping (T?, RequestError?, Bool?) -> Void) {
        var requestParameters = buildParameters(from: options)
        
        requestParameters["site"] = self.site
        requestParameters["key"] = self.key
        requestParameters["filter"] = self.filterName
        
        if requiresAccessToken {
            requestParameters["access_token"] = ""
        }
        
        Alamofire.request(self.apiDomain + endpoint, parameters: requestParameters, headers: self.headers).validate().responseJSON { responseInfo in
            print(responseInfo.timeline)
            
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
                let itemsData = try JSON(jsonData)["items"].rawData()
                let result = try self.jsonDecoder.decode(T.self, from: itemsData)
                completion(result, nil, responseWrapper.hasMore)
            } catch let error {
                print(error)
                completion(nil, RequestError.jsonParsingFailed, nil)
            }
        }
    }
}
