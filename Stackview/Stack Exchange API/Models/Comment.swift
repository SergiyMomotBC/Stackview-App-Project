//
//  Comment.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct Comment: Decodable {
    let bodyText: String?
    let bodyMarkdown: String?
    let canFlag: Bool?
    let id: Int?
    let creationDate: Date?
    let isEdited: Bool?
    let link: URL?
    let owner: ShallowUser?
    let postID: Int?
    let postType: PostType?
    let replyToUser: ShallowUser?
    var score: Int?
    var isUpvotedByCurrentUser: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case bodyText = "body"
        case bodyMarkdown = "body_markdown"
        case canFlag = "can_flag"
        case id = "comment_id"
        case creationDate = "creation_date"
        case isEdited = "edited"
        case link
        case owner
        case postID = "post_id"
        case postType = "post_type"
        case replyToUser = "reply_to_user"
        case score
        case isUpvotedByCurrentUser = "upvoted"
    }
}
