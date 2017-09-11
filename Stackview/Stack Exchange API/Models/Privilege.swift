//
//  Privilege.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct Privilege: Decodable {
    let description: String?
    let reputation: Int?
    let shortDescription: String?
    
    private enum CodingKeys: String, CodingKey {
        case description
        case reputation
        case shortDescription = "short_description"
    }
}
