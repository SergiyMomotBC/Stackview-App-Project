//
//  ResponseWrapper.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct ResponseWrapper: Decodable {
    let backoffTime: Int?
    let errorID: Int?
    let errorMessage: String?
    let errorName: String?
    let hasMore: Bool?
    let page: Int?
    let pageSize: Int?
    let quotaMax: Int?
    let quotaRemaining: Int?
    let total: Int?
    let type: String?
    
    private enum CodingKeys: String, CodingKey {
        case backoffTime = "backoff"
        case errorID = "error_id"
        case errorMessage = "error_message"
        case errorName = "error_name"
        case hasMore = "has_more"
        case page
        case pageSize = "page_size"
        case quotaMax = "quota_max"
        case quotaRemaining = "quota_remaining"
        case total
        case type
    }
}
