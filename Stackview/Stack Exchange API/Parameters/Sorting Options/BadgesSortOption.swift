//
//  BadgesSortOption.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/16/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

enum BadgesSortOption: SortOption {
    case rank(min: BadgeRank?, max: BadgeRank?)
    case name(min: String?, max: String?)
    case type(min: BadgeType?, max: BadgeType?)
    
    var parameters: [String : Any] {
        var params: [String: Any] = [:]
        
        switch self {
        case .rank(let min, let max):
            params[sortParameterName] = SortOptionName.rank.rawValue
            resolveMinMax(min: min?.rawValue, max: max?.rawValue, parameters: &params)
            
        case .name(let min, let max):
            params[sortParameterName] = SortOptionName.name.rawValue
            resolveMinMax(min: min, max: max, parameters: &params)
            
        case .type(let min, let max):
            params[sortParameterName] = SortOptionName.type.rawValue
            resolveMinMax(min: min?.rawValue, max: max?.rawValue, parameters: &params)
        }
        
        return params
    }
}
