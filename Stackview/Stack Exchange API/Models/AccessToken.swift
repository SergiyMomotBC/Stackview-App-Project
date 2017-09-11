//
//  AccessToken.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct AccessToken: Decodable {
    let token: String?
    let accountID: Int?
    let expirationDate: Date?
    let scopes: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case accountID = "account_id"
        case expirationDate = "expires_on_date"
        case scopes = "scope"
    }
}
