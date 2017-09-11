//
//  QuestionTimeline.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

enum QuestionTimelineType: String, Decodable {
    case question
    case answer
    case comment
    case unacceptedAnswer = "unaccepted_answer"
    case acceptedAnswer = "accepted_answer"
    case voteAggregate = "vote_aggregate"
    case revision
    case postStateChanged = "post_state_changed"
}

struct QuestionTimeline: Decodable {
    let commentID: Int?
    let creationDate: Date?
    let downvotesCount: Int?
    let owner: ShallowUser?
    let postID: Int?
    let questionID: Int?
    let revisionGUID: String?
    let type: QuestionTimelineType
    let upvotesCount: Int?
    let user: ShallowUser?
    
    private enum CodingKeys: String, CodingKey {
        case commentID = "comment_id"
        case creationDate = "creation_date"
        case downvotesCount = "down_vote_count"
        case owner
        case postID = "post_id"
        case questionID = "question_id"
        case revisionGUID = "revision_guid"
        case type = "timeline_type"
        case upvotesCount = "up_vote_count"
        case user
    }
}
