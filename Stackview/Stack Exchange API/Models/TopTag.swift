//
//  TopTag.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/15/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct TopTag: Decodable {
    let answersCount: Int?
    let answerScore: Int?
    let questionsCount: Int?
    let questionScore: Int?
    let tagName: String?
    let userID: Int?
    
    private enum CodingKeys: String, CodingKey {
        case answersCount = "answer_count"
        case answerScore = "answer_score"
        case questionsCount = "question_count"
        case questionScore = "question_score"
        case tagName = "tag_name"
        case userID = "user_id"
    }
}
