//
//  TagsSortOption.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/16/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

enum TagsSortOption: SortOption {
    case popular(min: Int?, max: Int?)
    case activity(min: Date?, max: Date?)
    case name(min: String?, max: String?)
    
    var parameters: [String : Any] {
        var params: [String: Any] = [:]
        
        switch self {
        case .popular(let min, let max):
            params[sortParameterName] = SortOptionName.popular.rawValue
            resolveMinMax(min: min, max: max, parameters: &params)
            
        case .activity(let min, let max):
            params[sortParameterName] = SortOptionName.activity.rawValue
            resolveMinMax(min: min, max: max, parameters: &params)
            
        case .name(let min, let max):
            params[sortParameterName] = SortOptionName.name.rawValue
            resolveMinMax(min: min, max: max, parameters: &params)
        }
        
        return params
    }
}
