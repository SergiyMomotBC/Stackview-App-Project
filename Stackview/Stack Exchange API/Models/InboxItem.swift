//
//  InboxItem.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

enum InboxItemType: String, Decodable {
    case comment
    case charMessage = "chat_message"
    case newAnswer = "new_answer"
    case careersMessage = "careers_message"
    case careersInvitations = "careers_invitations"
    case metaQuestion = "meta_question"
    case postNotice = "post_notice"
    case moderatorMessage = "moderator_message"
}

struct InboxItem: Decodable {
    let answerID: Int?
    let bodyText: String?
    let commentID: Int?
    let creationDate: Date?
    let isUnread: Bool?
    let type: InboxItemType?
    let link: URL?
    let questionID: Int?
    let site: Site?
    let title: String?
    
    private enum CodingKeys: String, CodingKey {
        case answerID = "answer_id"
        case bodyText = "body"
        case commentID = "comment_id"
        case creationDate = "creation_date"
        case isUnread = "is_unread"
        case type = "item_type"
        case link
        case questionID = "question_id"
        case site
        case title
    }
}
