//
//  TagSynonym.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/15/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct TagSynonym {
    let appliedCount: Int?
    let creationDate: Date?
    let fromTag: String?
    let lastAppliedDate: Date?
    let toTag: String?
    
    private enum CodingKeys: String, CodingKey {
        case appliedCount = "applied_count"
        case creationDate = "creation_date"
        case fromTag = "from_tag"
        case lastAppliedDate = "last_applied_date"
        case toTag = "to_tag"
    }
}
