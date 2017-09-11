//
//  ClosedDetails.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct ClosedDetails: Decodable {
    let byUsers: [ShallowUser]?
    let description: String?
    let isOnHold: Bool?
    let originalQuestions: [OriginalQuestion]?
    let reason: String?
    
    private enum CodingKeys: String, CodingKey {
        case byUsers = "by_users"
        case description
        case isOnHold = "on_hold"
        case originalQuestions = "original_questions"
        case reason
    }
}
