//
//  ReputationHistory.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

enum ReputationHistoryType: String, Decodable {
    case askerAcceptsAnswer = "asker_accepts_answer"
    case askerUnacceptAnswer = "asker_unaccepts_answer"
    case answerAccepted = "answer_accepted"
    case answerUnaccepted = "answer_unaccepted"
    case voterDownvotes = "voter_downvotes"
    case voterUndownvotes = "voter_undownvotes"
    case postDownvoted = "post_downvoted"
    case postUndownvoted = "post_undownvoted"
    case postUpvoted = "post_upvoted"
    case postUnupvoted = "post_unupvoted"
    case suggestedEditApprovalReceived = "suggested_edit_approval_received"
    case postFlaggedAsSpam = "post_flagged_as_spam"
    case postFlaggedAsOffensive = "post_flagged_as_offensive"
    case bountyGiven = "bounty_given"
    case bountyEarned = "bounty_earned"
    case bountyCancelled = "bounty_cancelled"
    case postDeleted = "post_deleted"
    case postUndeleted = "post_undeleted"
    case associationBonus = "association_bonus"
    case arbitraryReputationChange = "arbitrary_reputation_change"
    case voteFraudReversal = "vote_fraud_reversal"
    case postMigrated = "post_migrated"
    case userDeleted = "user_deleted"
    case exampleUpvoted = "example_upvoted"
    case exampleUnupvoted = "example_unupvoted"
    case proposedChangeApproved = "proposed_change_approved"
    case docLinkUpvoted = "doc_link_upvoted"
    case docLinkUnupvoted = "doc_link_unupvoted"
    case docSourceRemoved = "doc_source_removed"
    case suggestedEditApprovalOverridden = "suggested_edit_approval_overridden"
}

struct ReputaionHistory: Decodable {
    let creationDate: Date?
    let postID: Int?
    let reputationChange: Int?
    let type: ReputationHistoryType?
    let userID: Int?
    
    private enum CodingKeys: String, CodingKey {
        case creationDate = "creation_date"
        case postID = "post_id"
        case reputationChange = "reputation_change"
        case type = "reputation_history_type"
        case userID = "user_id"
    }
}
