//
//  Notification.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct Notification: Decodable {
    let bodyText: String?
    let creationDate: Date?
    let isUnread: Bool?
    let type: String?
    let postID: Int?
    let site: Site?
    
    private enum CodingKeys: String, CodingKey {
        case bodyText = "body"
        case creationDate = "creation_date"
        case isUnread = "is_unread"
        case type = "notification_type"
        case postID = "post_id"
        case site
    }
}
