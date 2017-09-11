//
//  Event.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

enum EventType: String, Decodable {
    case questionPosted = "question_posted"
    case answerPosted = "answer_posted"
    case commentPosted = "comment_posted"
    case postEdited = "post_edited"
    case userCreated = "user_created"
}

struct Event: Decodable {
    let creationDate: Date?
    let id: Int?
    let type: EventType?
    let excerpt: String?
    let link: URL?
    
    private enum CodingKeys: String, CodingKey {
        case creationDate = "creation_date"
        case id = "event_id"
        case type = "event_type"
        case excerpt
        case link
    }
}
