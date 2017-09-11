//
//  UsersSortOption.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/16/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

enum UsersSortOption: SortOption {
    case reputation(min: Int?, max: Int?)
    case creation
    case name(min: String?, max: String?)
    case modified(min: Date?, max: Date?)
    
    var parameters: [String : Any] {
        var params: [String: Any] = [:]
        
        switch self {
        case .reputation(let min, let max):
            params[sortParameterName] = SortOptionName.reputation.rawValue
            resolveMinMax(min: min, max: max, parameters: &params)
            
        case .creation:
            params[sortParameterName] = SortOptionName.creation.rawValue
            
        case .name(let min, let max):
            params[sortParameterName] = SortOptionName.name.rawValue
            resolveMinMax(min: min, max: max, parameters: &params)
            
        case .modified(let min, let max):
            params[sortParameterName] = SortOptionName.modified.rawValue
            resolveMinMax(min: min, max: max, parameters: &params)
        }
        
        return params
    }
}
