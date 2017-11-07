//
//  IntitleSearchParameter.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/28/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

struct IntitleSearchParameter: ParametersConvertible {
    private let innameParameterName = "intitle"
    var query: String
    
    var parameters: [String : Any] {
        return [innameParameterName: query.lowercased()]
    }
}
