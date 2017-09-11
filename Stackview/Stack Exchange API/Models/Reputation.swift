//
//  Reputation.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

enum ReputationVoteType: String, Decodable {
    case accepts
    case upVotes = "up_votes"
    case downVotes = "down_votes"
    case bountiesOffered = "bounties_offered"
    case bountiesWon = "bounties_won"
    case spam
    case suggestedEdits = "suggested_edits"
}

struct Reputation: Decodable {
    let link: URL?
    let onDate: Date?
    let postID: Int?
    let postType: PostType?
    let reputationChange: Int?
    let title: String
    let userID: Int?
    let voteType: ReputationVoteType?
    
    private enum CodingKeys: String, CodingKey {
        case link
        case onDate = "on_date"
        case postID = "post_id"
        case postType = "post_type"
        case reputationChange = "reputation_change"
        case title
        case userID = "user_id"
        case voteType = "vote_type"
    }
}
