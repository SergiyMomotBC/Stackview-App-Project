//
//  Notice.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct Notice: Decodable {
    let bodyText: String?
    let creationDate: Date?
    let ownerUserID: Int?
    
    private enum CodingKeys: String, CodingKey {
        case bodyText = "text"
        case creationDate = "creation_date"
        case ownerUserID = "owner_user_id"
    }
}
