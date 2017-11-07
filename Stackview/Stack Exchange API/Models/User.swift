//
//  User.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/15/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

enum UserType: String, Codable {
    case unregistered
    case registered
    case moderator
    case notExisting = "does_not_exist"
}

struct User: Codable {
    let aboutMeText: String?
    let acceptRate: Int?
    let accountID: Int?
    let age: Int?
    let answersCount: Int?
    let badgeCounts: BadgeCount?
    let creationDate: Date?
    let name: String?
    let downvotesCount: Int?
    let isEmployee: Bool?
    let lastAccessDate: Date?
    let lastModifiedDate: Date?
    let link: URL?
    let location: String?
    let profileImageURL: URL?
    let questionsCount: Int?
    let reputation: Int?
    let reputationChangeDaily: Int?
    let reputationChangeMonthly: Int?
    let reputationChangeQuarterly: Int?
    let reputationChangeWeekly: Int?
    let reputationChangeYearly: Int?
    let timedPenaltyDate: Date?
    let upvotesCount: Int?
    let id: Int?
    let type: UserType?
    let viewsCount: Int?
    let websiteURL: String?
    
    private enum CodingKeys: String, CodingKey {
        case aboutMeText = "about_me"
        case acceptRate = "accept_rate"
        case accountID = "account_id"
        case age
        case answersCount = "answer_count"
        case badgeCounts = "badge_counts"
        case creationDate = "creation_date"
        case name = "display_name"
        case downvotesCount = "down_vote_count"
        case isEmployee = "is_employee"
        case lastAccessDate = "last_access_date"
        case lastModifiedDate = "last_modified_date"
        case link
        case location
        case profileImageURL = "profile_image"
        case questionsCount = "question_count"
        case reputation
        case reputationChangeDaily = "reputation_change_day"
        case reputationChangeMonthly = "reputation_change_month"
        case reputationChangeQuarterly = "reputation_change_quarter"
        case reputationChangeWeekly = "reputation_change_week"
        case reputationChangeYearly = "reputation_change_year"
        case timedPenaltyDate = "timed_penalty_date"
        case upvotesCount = "up_vote_count"
        case id = "user_id"
        case type = "user_type"
        case viewsCount = "view_count"
        case websiteURL = "website_url"
    }
}
