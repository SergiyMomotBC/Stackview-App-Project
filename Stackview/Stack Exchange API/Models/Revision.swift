//
//  Revision.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/15/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

enum RevisionType: String, Decodable {
    case singleUser = "single_user"
    case voteBased = "vote_based"
}

struct Revision: Decodable {
    let bodyText: String?
    let commentText: String?
    let creationDate: Date?
    let isRollback: Bool?
    let lastBodyText: String?
    let lastTags: [String]?
    let lastTitle: String?
    let postID: Int?
    let postType: PostType?
    let revisionGUID: String?
    let revisionNumber: Int?
    let type: RevisionType?
    let isSetCommunityWiki: Bool?
    let tags: [String]?
    let title: String?
    let user: ShallowUser?
    
    private enum CodingKeys: String, CodingKey {
        case bodyText = "body"
        case commentText = "comment"
        case creationDate = "creation_date"
        case isRollback = "is_rollback"
        case lastBodyText = "last_body"
        case lastTags = "last_tags"
        case lastTitle = "last_title"
        case postID = "post_id"
        case postType = "post_type"
        case revisionGUID = "revision_guid"
        case revisionNumber = "revision_number"
        case type = "revision_type"
        case isSetCommunityWiki = "set_community_wiki"
        case tags
        case title
        case user
    }
}
