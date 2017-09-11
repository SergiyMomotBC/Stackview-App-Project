//
//  SuggestedEdit.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/15/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct SuggestedEdit: Decodable {
    let approvalDate: Date?
    let bodyText: String?
    let commentText: String?
    let creationDate: Date?
    let postID: Int?
    let postType: PostType?
    let proposingUser: ShallowUser?
    let rejectionDate: Date?
    let id: Int?
    let tags: [String]?
    let title: String?
    
    private enum CodingKeys: String, CodingKey {
        case approvalDate = "approval_date"
        case bodyText = "body"
        case commentText = "comment"
        case creationDate = "creation_date"
        case postID = "post_id"
        case postType = "post_type"
        case proposingUser = "proposing_user"
        case rejectionDate = "rejection_date"
        case id = "suggested_edit_id"
        case tags
        case title
    }
}
