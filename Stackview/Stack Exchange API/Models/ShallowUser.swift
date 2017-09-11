//
//  ShallowUser.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct ShallowUser: Decodable {
    let acceptRate: Int?
    let badgeCounts: BadgeCount?
    let name: String?
    let link: URL?
    let profileImageURL: URL?
    let reputation: Int?
    let id: Int?
    let type: UserType?
    
    private enum CodingKeys: String, CodingKey {
        case acceptRate = "accept_rate"
        case badgeCounts = "badge_counts"
        case name = "display_name"
        case link
        case profileImageURL = "profile_image"
        case reputation
        case id = "user_id"
        case type = "user_type"
    }
}
