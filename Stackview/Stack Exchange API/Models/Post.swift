//
//  Post.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

enum PostType: String, Decodable {
    case question
    case answer
}

struct Post: Decodable {
    let bodyText: String?
    let bodyMarkdown: String?
    let commentsCount: Int?
    let comments: [Comment]?
    let creationDate: Date?
    let downvoteCount: Int?
    let isDownvotedByCurrentUser: Bool?
    let lastActivityDate: Date?
    let lastEditDate: Date?
    let lastEditor: ShallowUser?
    let link: URL?
    let owner: ShallowUser?
    let id: Int?
    let type: PostType?
    let score: Int?
    let shareLink: URL?
    let title: String?
    let upvoteCount: Int?
    let isUpvotedByCurrentUser: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case bodyText = "body"
        case bodyMarkdown = "body_markdown"
        case commentsCount = "comment_count"
        case comments
        case creationDate = "creation_date"
        case downvoteCount = "down_vote_count"
        case isDownvotedByCurrentUser = "downvoted"
        case lastActivityDate = "last_activity_date"
        case lastEditDate = "last_edit_date"
        case lastEditor = "last_editor"
        case link
        case owner
        case id = "post_id"
        case type = "post_type"
        case score
        case shareLink = "share_link"
        case title
        case upvoteCount = "up_vote_count"
        case isUpvotedByCurrentUser = "upvoted"
    }
}
