//
//  TagSynonymsSortOption.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/16/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

enum TagSynonymsSortOption: SortOption {
    case creation
    case activity(min: Date?, max: Date?)
    case applied(min: Int?, max: Int?)
    
    var parameters: [String : Any] {
        var params: [String: Any] = [:]
        
        switch self {
        case .creation:
            params[sortParameterName] = SortOptionName.creation.rawValue
            
        case .activity(let min, let max):
            params[sortParameterName] = SortOptionName.activity.rawValue
            resolveMinMax(min: min, max: max, parameters: &params)
            
        case .applied(let min, let max):
            params[sortParameterName] = SortOptionName.applied.rawValue
            resolveMinMax(min: min, max: max, parameters: &params)
        }
        
        return params
    }
}
