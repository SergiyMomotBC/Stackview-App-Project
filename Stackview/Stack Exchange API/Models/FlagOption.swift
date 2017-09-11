//
//  FlagOption.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct FlagOption: Decodable {
    let count: Int?
    let description: String?
    let dialogTitle: String?
    let hasFlagged: Bool?
    let id: Int?
    let isCommentRequired: Bool?
    let isQuestionIDRequired: Bool?
    let isSiteRequired: Bool?
    let suboptions: [FlagOption]?
    let title: String?
    
    private enum CodingKeys: String, CodingKey {
        case count
        case description
        case dialogTitle = "dialog_title"
        case hasFlagged = "has_flagged"
        case id = "option_id"
        case isCommentRequired = "requires_comment"
        case isQuestionIDRequired = "requires_question_id"
        case isSiteRequired = "requires_site"
        case suboptions = "sub_options"
        case title
    }
}
