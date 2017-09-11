//
//  SortingParameters.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/16/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct SortingParameters<Options: SortOption>: ParametersConvertible {
    let order: SortingOrder
    let option: Options
    
    init(option: Options, order: SortingOrder) {
        self.order = order
        self.option = option
    }
    
    var parameters: [String : Any] {
        return order.parameters.merging(option.parameters) { (current, _) in current }
    }
}
