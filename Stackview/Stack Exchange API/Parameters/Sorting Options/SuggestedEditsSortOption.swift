//
//  SuggestedEditsSortOption.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/16/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

enum SuggestedEditsSortOption: SortOption {
    case creation
    case approval(min: Date?, max: Date?)
    case rejection(min: Date?, max: Date?)
    
    var parameters: [String: Any] {
        var params: [String: Any] = [:]
        
        switch self {
        case .creation:
            params[sortParameterName] = SortOptionName.creation.rawValue
            
        case .approval(let min, let max):
            params[sortParameterName] = SortOptionName.approval.rawValue
            resolveMinMax(min: min, max: max, parameters: &params)
            
        case .rejection(let min, let max):
            params[sortParameterName] = SortOptionName.rejection.rawValue
            resolveMinMax(min: min, max: max, parameters: &params)
        }
        
        return params
    }
}
