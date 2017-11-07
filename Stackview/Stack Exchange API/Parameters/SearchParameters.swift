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
    private let acceptedParameterName = "accepted"
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
    private let fromDateParameterName = "fromdate"
    private let toDateParameterName = "todate"
    
    var query: String?
    var minAnswers: Int?
    var bodyText: String?
    var isAccepted: Bool?
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
    var fromDate: Date?
    var toDate: Date?
    
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
        
        if let isAccepted = self.isAccepted {
            params[acceptedParameterName] = isAccepted ? "True" : "False"
        }
        
        if let isClosed = self.isClosed {
            params[closedParameterName] = isClosed ? "True" : "False"
        }
        
        if let isMigrated = self.isMigrated {
            params[migratedParameterName] = isMigrated ? "True" : "False"
        }
        
        if let hasNotice = self.hasNotice {
            params[noticeParameterName] = hasNotice ? "True" : "False"
        }
        
        if let notTaggedList = self.notTaggedList {
            params[notTaggedParameterName] = notTaggedList.joined(separator: ";")
        }
        
        if let taggedList = self.taggedList {
            params[taggedParameterName] = taggedList.joined(separator: ";")
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
            params[wikiParameterName] = isWiki ? "True" : "False"
        }
        
        if let date = self.fromDate {
            params[fromDateParameterName] = date.timeIntervalSince1970
        }
        
        if let date = self.toDate {
            params[toDateParameterName] = date.timeIntervalSince1970
        }
        
        return params
    }
    
}
