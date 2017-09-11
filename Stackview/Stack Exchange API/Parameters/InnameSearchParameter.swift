//
//  InnameSearchParameter.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/11/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

struct InnameSearchParameter: ParametersConvertible {
    private let innameParameterName = "inname"
    var query: String
    
    var parameters: [String : Any] {
        return [innameParameterName: query.lowercased()]
    }
}
