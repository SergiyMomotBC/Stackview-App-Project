//
//  OriginalQuestion.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct OriginalQuestion: Decodable {
    let acceptedAnswerID: Int?
    let answersCount: Int?
    let questionID: Int?
    let title: String?
    
    private enum CodingKeys: String, CodingKey {
        case acceptedAnswerID = "accepted_answer_id"
        case answersCount = "answer_count"
        case questionID = "question_id"
        case title
    }
}
