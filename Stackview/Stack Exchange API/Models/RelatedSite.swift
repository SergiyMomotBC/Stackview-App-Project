//
//  RelatedSite.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/15/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct RelatedSite: Decodable {
    let apiSiteParameter: String?
    let name: String?
    let relation: String?
    let siteURL: URL?
    
    private enum CodingKeys: String, CodingKey {
        case apiSiteParameter = "api_site_parameter"
        case name
        case relation
        case siteURL = "site_url"
    }
}
