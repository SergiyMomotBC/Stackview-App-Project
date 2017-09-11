//
//  AddedQuestionsSortOption.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/16/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

enum AddedQuestionsSortOption: SortOption {
    case activity(min: Date?, max: Date?)
    case creation
    case votes(min: Int?, max: Int?)
    case added(min: Date?, max: Date?)
    
    var parameters: [String : Any] {
        var params: [String: Any] = [:]
        
        switch self {
        case .activity(let min, let max):
            params[sortParameterName] = SortOptionName.activity.rawValue
            resolveMinMax(min: min, max: max, parameters: &params)
            
        case .creation:
            params[sortParameterName] = SortOptionName.creation.rawValue
            
        case .votes(let min, let max):
            params[sortParameterName] = SortOptionName.votes.rawValue
            resolveMinMax(min: min, max: max, parameters: &params)
            
        case .added(let min, let max):
            params[sortParameterName] = SortOptionName.added.rawValue
            resolveMinMax(min: min, max: max, parameters: &params)
        }
        
        return params
    }
}
