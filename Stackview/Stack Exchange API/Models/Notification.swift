//
//  Notification.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

enum NotificationType: String, Decodable {
    case generic
    case profileActivity = "profile_activity"
    case bountyExpired = "bounty_expired"
    case bountyExpiresInOneDay = "bounty_expires_in_one_day"
    case badgeEarned = "badge_earned"
    case bountyExpiresInThreeDays = "bounty_expires_in_three_days"
    case reputationBonus = "reputation_bonus"
    case accountsAssociated = "accounts_associated"
    case newPrivilege = "new_privilege"
    case postMigrated = "post_migrated"
    case moderatorMessage = "moderator_message"
    case registrationReminder = "registration_reminder"
    case editSuggested = "edit_suggested"
    case substantiveEdit = "substantive_edit"
    case bountyGracePeriodStarted = "bounty_grace_perios_started"
}

struct Notification: Decodable {
    let bodyText: String?
    let creationDate: Date?
    let isUnread: Bool?
    let type: NotificationType?
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
