//
//  WritePermission.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/15/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct WritePermission: Decodable {
    let canAdd: Bool?
    let canDelete: Bool?
    let canEdit: Bool?
    let maxDailyActions: Int?
    let minSecondsBetweenActions: Int?
    let objectType: String?
    let userID: Int?
    
    private enum CodingKeys: String, CodingKey {
        case canAdd = "can_add"
        case canDelete = "can_delete"
        case canEdit = "can_edit"
        case maxDailyActions = "max_daily_actions"
        case minSecondsBetweenActions = "min_seconds_between_actions"
        case objectType = "object_type"
        case userID = "user_id"
    }
}
