//
//  TagScore.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/15/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct TagScore: Decodable {
    let postsCount: Int?
    let score: Int?
    let user: ShallowUser?
    
    private enum CodingKeys: String, CodingKey {
        case postsCount = "post_count"
        case score
        case user
    }
}
