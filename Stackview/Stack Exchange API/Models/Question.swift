//
//  Question.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct Question: Decodable {
    let acceptedAnswerID: Int?
    let answersCount: Int?
    let answers: [Answer]?
    let bodyText: String?
    let bodyMarkdown: String?
    let bountyAmount: Int?
    let bountyClosesDate: Date?
    let bountyUser: ShallowUser?
    let canClose: Bool?
    let canFlag: Bool?
    let closeVotesCount: Int?
    let closedDate: Date?
    let closedDetails: ClosedDetails?
    let closedReason: String?
    let commentsCount: Int?
    let comments: [Comment]?
    let communityOwnedDate: Date?
    let creationDate: Date?
    let deleteVotesCount: Int?
    let downvoteCount: Int?
    let isDownvotedByCurrentUser: Bool?
    let favoritesCount: Int?
    let isFavoritedByCurrentUser: Bool?
    let isAnswered: Bool?
    let lastActivityDate: Date?
    let lastEditDate: Date?
    let lastEditor: ShallowUser?
    let link: URL?
    let lockedDate: Date?
    let migratedFrom: MigrationInfo?
    let migratedTo: MigrationInfo?
    let notice: Notice?
    let owner: ShallowUser?
    let protectedDate: Date?
    let id: Int?
    let reopenVotesCount: Int?
    let score: Int?
    let shareLink: URL?
    let tags: [String]?
    let title: String?
    let upvoteCount: Int?
    let isUpvotedByCurrentUser: Bool?
    let viewsCount: Int?
    
    private enum CodingKeys: String, CodingKey {
        case acceptedAnswerID = "accepted_answer_id"
        case answersCount = "answer_count"
        case answers
        case bodyText = "body"
        case bodyMarkdown = "body_markdown"
        case bountyAmount = "bounty_amount"
        case bountyClosesDate = "bounty_closes_date"
        case bountyUser = "bounty_user"
        case canClose = "can_close"
        case canFlag = "can_flag"
        case closeVotesCount = "close_vote_count"
        case closedDate = "closed_date"
        case closedDetails = "closed_details"
        case closedReason = "closed_reason"
        case commentsCount = "comment_count"
        case comments
        case communityOwnedDate = "community_owned_date"
        case creationDate = "creation_date"
        case deleteVotesCount = "delete_vote_count"
        case downvoteCount = "down_vote_count"
        case isDownvotedByCurrentUser = "downvoted"
        case favoritesCount = "favorite_count"
        case isFavoritedByCurrentUser = "favorited"
        case isAnswered = "is_answered"
        case lastActivityDate = "last_activity_date"
        case lastEditDate = "last_edit_date"
        case lastEditor = "last_editor"
        case link
        case lockedDate = "locked_date"
        case migratedFrom = "migrated_from"
        case migratedTo = "migrated_to"
        case notice
        case owner
        case protectedDate = "protected_date"
        case id = "question_id"
        case reopenVotesCount = "reopen_vote_count"
        case score
        case shareLink = "share_link"
        case tags
        case title
        case upvoteCount = "up_vote_count"
        case isUpvotedByCurrentUser = "upvoted"
        case viewsCount = "view_count"
    }
}
