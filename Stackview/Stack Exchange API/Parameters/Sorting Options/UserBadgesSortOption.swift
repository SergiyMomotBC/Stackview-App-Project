//
//  UserBadgesSortOption.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/13/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

enum UserBadgesSortOption: SortOption {
    case rank(min: BadgeRank?, max: BadgeRank?)
    case name(min: String?, max: String?)
    case type(min: BadgeType?, max: BadgeType?)
    case awarded
    
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
            
        case .awarded:
            params[sortParameterName] = SortOptionName.awarded.rawValue
        }
        
        return params
    }
}
