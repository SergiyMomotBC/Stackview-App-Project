//
//  NetworkUser.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct NetworkUser: Decodable {
    let accountID: Int?
    let answersCount: Int?
    let badgeCounts: BadgeCount?
    let creationDate: Date?
    let lastAccessDate: Date?
    let questionsCount: Int?
    let reputation: Int?
    let siteName: String?
    let siteURL: URL?
    let topAnswers: [NetworkPost]?
    let topQuestions: [NetworkPost]?
    let userID: Int?
    let userType: UserType?
    
    private enum CodingKeys: String, CodingKey {
        case accountID = "account_id"
        case answersCount = "answer_count"
        case badgeCounts = "badge_counts"
        case creationDate = "creation_date"
        case lastAccessDate = "last_access_date"
        case questionsCount = "question_count"
        case reputation
        case siteName = "site_name"
        case siteURL = "site_url"
        case topAnswers = "top_answers"
        case topQuestions = "top_questions"
        case userID = "user_id"
        case userType = "user_type"
    }
}
