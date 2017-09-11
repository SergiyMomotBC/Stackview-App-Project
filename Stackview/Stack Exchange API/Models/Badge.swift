//
//  Badge.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

enum BadgeType: String, Decodable {
    case named
    case tagBased = "tag_based"
}

enum BadgeRank: String, Decodable {
    case gold
    case silver
    case bronze
}

struct Badge: Decodable {
    let awardCount: Int?
    let id: Int?
    let type: BadgeType?
    let description: String?
    let link: URL?
    let name: String?
    let rank: BadgeRank?
    let user: ShallowUser?
    
    private enum CodingKeys: String, CodingKey {
        case awardCount = "award_count"
        case id = "badge_id"
        case type = "badge_type"
        case description
        case link
        case name
        case rank
        case user
    }
}
