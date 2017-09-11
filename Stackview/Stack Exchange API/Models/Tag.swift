//
//  Tag.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/15/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct Tag: Decodable {
    let count: Int?
    let hasSynonyms: Bool?
    let isModeratorOnly: Bool?
    let isRequired: Bool?
    let lastActivityDate: Date?
    let name: String?
    let synonyms: [String]?
    let userID: Int?
    
    private enum CodingKeys: String, CodingKey {
        case count
        case hasSynonyms = "has_synonyms"
        case isModeratorOnly = "is_moderator_only"
        case isRequired = "is_required"
        case lastActivityDate = "last_activity_date"
        case name
        case synonyms
        case userID = "user_id"
    }
}
