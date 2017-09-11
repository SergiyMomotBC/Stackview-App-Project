//
//  SearchParameters.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/28/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct SearchParameters: ParametersConvertible {
    private let queryParameterName = "q"
    private let minAnswersParameterName = "answers"
    private let bodyTextParameterName = "body"
    private let closedParameterName = "closed"
    private let migratedParameterName = "migrated"
    private let noticeParameterName = "notice"
    private let notTaggedParameterName = "nottagged"
    private let taggedParameterName = "tagged"
    private let titleTextParameterName = "title"
    private let userParameterName = "user"
    private let urlParameterName = "url"
    private let viewsParameterName = "views"
    private let wikiParameterName = "wiki"
    
    var query: String?
    var minAnswers: Int?
    var bodyText: String?
    var isClosed: Bool?
    var isMigrated: Bool?
    var hasNotice: Bool?
    var notTaggedList: [String]?
    var taggedList: [String]?
    var titleText: String?
    var userID: Int?
    var url: String?
    var minViews: Int?
    var isWiki: Bool?
    
    var parameters: [String : Any] {
        var params: [String: Any] = [:]
        
        if let query = self.query {
            params[queryParameterName] = query
        }
        
        if let minAnswers = self.minAnswers {
            params[minAnswersParameterName] = minAnswers
        }
        
        if let bodyText = self.bodyText {
            params[bodyTextParameterName] = bodyText
        }
        
        if let isClosed = self.isClosed {
            params[closedParameterName] = isClosed
        }
        
        if let isMigrated = self.isMigrated {
            params[migratedParameterName] = isMigrated
        }
        
        if let hasNotice = self.hasNotice {
            params[noticeParameterName] = hasNotice
        }
        
        if let notTaggedList = self.notTaggedList {
            params[notTaggedParameterName] = notTaggedList
        }
        
        if let taggedList = self.taggedList {
            params[taggedParameterName] = taggedList
        }
        
        if let titleText = self.titleText {
            params[titleTextParameterName] = titleText
        }
        
        if let userID = self.userID {
            params[userParameterName] = userID
        }
        
        if let url = self.url {
            params[urlParameterName] = url
        }
        
        if let minViews = self.minViews {
            params[viewsParameterName] = minViews
        }
        
        if let isWiki = self.isWiki {
            params[wikiParameterName] = isWiki
        }
        
        return params
    }
    
}
