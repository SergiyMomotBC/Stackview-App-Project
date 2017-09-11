//
//  QuestionsAdvancedSortOption.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/16/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

enum QuestionsAdvancedSortOption: SortOption {
    case activity(min: Date?, max: Date?)
    case creation
    case votes(min: Int?, max: Int?)
    case hot
    case week
    case month
    
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
            
        case .hot:
            params[sortParameterName] = SortOptionName.hot.rawValue
            
        case .week:
            params[sortParameterName] = SortOptionName.week.rawValue
            
        case .month:
            params[sortParameterName] = SortOptionName.month.rawValue
        }
        
        return params
    }
}
