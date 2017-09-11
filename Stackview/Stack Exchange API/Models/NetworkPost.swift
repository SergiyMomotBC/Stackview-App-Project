//
//  NetworkPost.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct NetworkPost: Decodable {
    let postID: Int?
    let postType: PostType?
    let score: Int?
    let title: String?
    
    private enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case postType = "post_type"
        case score
        case title
    }
}
