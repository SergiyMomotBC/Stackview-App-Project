//
//  SearchExcerpt.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/15/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct SearchExcerpt: Decodable {
    let answersCount: Int?
    let answerID: Int?
    let bodyText: String?
    let closedDate: Date?
    let communityOwnedDate: Date?
    let creationDate: Date?
    let equivalentTagSearch: [String]?
    let excerptText: String?
    let hasAcceptedAnswer: Bool?
    let isAccepted: Bool?
    let isAnswered: Bool?
    let itemType: PostType?
    let lastActivityDate: Date?
    let lastActivityUser: ShallowUser?
    let lockedDate: Date?
    let owner: ShallowUser?
    let questionID: Int?
    let questionScore: Int?
    let score: Int?
    let tags: [String]?
    let title: String?

    private enum CodingKeys: String, CodingKey {
        case answersCount = "answer_count"
        case answerID = "answer_id"
        case bodyText = "body"
        case closedDate = "closed_date"
        case communityOwnedDate = "community_owned_date"
        case creationDate = "creation_date"
        case equivalentTagSearch = "equivalent_tag_search"
        case excerptText = "excerpt"
        case hasAcceptedAnswer = "has_accepted_answer"
        case isAccepted = "is_accepted"
        case isAnswered = "is_answered"
        case itemType = "item_type"
        case lastActivityDate = "last_activity_date"
        case lastActivityUser = "last_activity_user"
        case lockedDate = "locked_date"
        case owner
        case questionID = "question_id"
        case questionScore = "question_score"
        case score
        case tags
        case title
    }
}
