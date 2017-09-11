//
//  NetworkActivity.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

enum NetworkActivityType: String, Decodable {
    case questionPosted = "question_posted"
    case answerPosted = "answer_posted"
    case badgeEarned = "badge_earned"
    case commentPosted = "comment_posted"
}

struct NetworkActivity: Decodable {
    let accountID: Int?
    let type: NetworkActivityType?
    let apiSiteParameter: String?
    let badgeID: Int?
    let creationDate: Date?
    let description: String?
    let link: URL?
    let postID: Int?
    let score: Int?
    let tags: [String]?
    let title: String
    
    private enum CodingKeys: String, CodingKey {
        case accountID = "account_id"
        case type = "activity_type"
        case apiSiteParameter = "api_site_parameter"
        case badgeID = "badge_id"
        case creationDate = "creation_date"
        case description
        case link
        case postID = "post_id"
        case score
        case tags
        case title
    }
}
