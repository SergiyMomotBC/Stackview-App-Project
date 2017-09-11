//
//  Info.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct Info: Decodable {
    let answersPerMinute: Float?
    let apiRevision: String?
    let badgesPerMinute: Float?
    let newActiveUsers: Int?
    let questionsPerMinute: Float?
    let site: Site?
    let totalAcceptedAnswers: Int?
    let totalAnswers: Int?
    let totalBadges: Int?
    let totalComments: Int?
    let totalQuestions: Int?
    let totalUnanswered: Int?
    let totalUsers: Int?
    let totalVotes: Int?
    
    private enum CodingKeys: String, CodingKey {
        case answersPerMinute = "answers_per_minute"
        case apiRevision = "api_revision"
        case badgesPerMinute = "badges_per_minute"
        case newActiveUsers = "new_active_users"
        case questionsPerMinute = "questions_per_minute"
        case site
        case totalAcceptedAnswers = "total_accepted"
        case totalAnswers = "total_answers"
        case totalBadges = "total_badges"
        case totalComments = "total_comments"
        case totalQuestions = "total_questions"
        case totalUnanswered = "total_unanswered"
        case totalUsers = "total_users"
        case totalVotes = "total_votes"
    }
}
