//
//  Site.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/15/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

enum SiteState: String, Decodable {
    case normal
    case closedBeta = "closed_beta"
    case openBeta = "open_beta"
    case linkedMeta = "linked_meta"
}

enum SiteType: String, Decodable {
    case main = "main_site"
    case meta = "meta_site"
}

struct Site: Decodable {
    let aliases: [String]?
    let apiSiteParameter: String?
    let audience: String?
    let closedBetaDate: Date?
    let faviconURL: URL?
    let highResolutionIconURL: URL?
    let iconURL: URL?
    let launchDate: Date?
    let logoURL: URL?
    let markdownExtensions: [String]?
    let name: String?
    let openBetaDate: Date?
    let relatedSites: [RelatedSite]?
    let state: SiteState?
    let type: SiteType?
    let url: URL?
    let styling: Styling?
    let twitterAccount: String?
    
    private enum CodingKeys: String, CodingKey {
        case aliases
        case apiSiteParameter = "api_site_parameter"
        case audience
        case closedBetaDate = "closed_beta_date"
        case faviconURL = "favicon_url"
        case highResolutionIconURL = "high_resolution_icon_url"
        case iconURL = "icon_url"
        case launchDate = "launch_date"
        case logoURL = "logo_url"
        case markdownExtensions = "markdown_extensions"
        case name
        case openBetaDate = "open_beta_name"
        case relatedSites = "related_sites"
        case state = "site_state"
        case type = "site_type"
        case url = "site_url"
        case styling
        case twitterAccount = "twitter_account"
    }
}
