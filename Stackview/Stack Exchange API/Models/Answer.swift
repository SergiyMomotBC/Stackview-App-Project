//
//  Answer.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct Answer: Decodable {
    let isAcceptedByCurrentUser: Bool?
    let id: Int?
    let awardedBountyAmount: Int?
    let awardedBountyUsers: [ShallowUser]?
    let bodyText: String?
    let bodyMarkdown: String?
    let canFlag: Bool?
    let commentsCount: Int?
    let comments: [Comment]?
    let communityOwnedDate: Date?
    let creationDate: Date?
    let downvoteCount: Int?
    let isDownvotedByCurrentUser: Bool?
    let isAccepted: Bool?
    let lastActivityDate: Date?
    let lastEditDate: Date?
    let lastEditor: ShallowUser?
    let link: URL?
    let lockedDate: Date?
    let owner: ShallowUser?
    let questionID: Int?
    let score: Int?
    let shareLink: URL?
    let tags: [String]?
    let title: String?
    let upvoteCount: Int?
    let isUpvotedByCurrentUser: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case isAcceptedByCurrentUser = "accepted"
        case id = "answer_id"
        case awardedBountyAmount = "awarded_bounty_amount"
        case awardedBountyUsers = "awarded_bounty_users"
        case bodyText = "body"
        case bodyMarkdown = "body_markdown"
        case canFlag = "can_flag"
        case commentsCount = "comment_count"
        case comments
        case communityOwnedDate = "community_owned_date"
        case creationDate = "creation_date"
        case downvoteCount = "down_vote_count"
        case isDownvotedByCurrentUser = "downvoted"
        case isAccepted = "is_accepted"
        case lastActivityDate = "last_activity_date"
        case lastEditDate = "last_edit_date"
        case lastEditor = "last_editor"
        case link
        case lockedDate = "locked_date"
        case owner
        case questionID = "question_id"
        case score
        case shareLink = "share_link"
        case tags
        case title
        case upvoteCount = "up_vote_count"
        case isUpvotedByCurrentUser = "upvoted"
    }
}
