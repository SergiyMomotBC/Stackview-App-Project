//
//  SortOption.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/16/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

fileprivate let minParameterName = "min"
fileprivate let maxParameterName = "max"

protocol SortOption: ParametersConvertible {}

extension SortOption {
    var sortParameterName: String {
        return "sort"
    }
    
    func resolveMinMax(min: Any?, max: Any?, parameters: inout [String: Any]) {
        if let minValue = min {
            parameters[minParameterName] = minValue
        }
        
        if let maxValue = max {
            parameters[maxParameterName] = maxValue
        }
    }
}
