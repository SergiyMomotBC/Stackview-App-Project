//
//  File.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/15/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct Error: Decodable {
    let description: String?
    let id: Int?
    let name: String?
    
    private enum CodingKeys: String, CodingKey {
        case description
        case id = "error_id"
        case name = "error_name"
    }
}
