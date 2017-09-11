//
//  TagWiki.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/15/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct TagWiki: Decodable {
    let bodyText: String?
    let bodyLastEditDate: Date?
    let excerptText: String?
    let excerptLastEditDate: Date?
    let lastBodyEditor: ShallowUser?
    let lastExcerptEditor: ShallowUser?
    let tagName: String?
    
    private enum CodingKeys: String, CodingKey {
        case bodyText = "body"
        case bodyLastEditDate = "body_last_edit_date"
        case excerptText = "excerpt"
        case excerptLastEditDate = "excerpt_last_edit_date"
        case lastBodyEditor = "last_body_editor"
        case lastExcerptEditor = "last_excerpt_editor"
        case tagName = "tag_name"
    }
}
