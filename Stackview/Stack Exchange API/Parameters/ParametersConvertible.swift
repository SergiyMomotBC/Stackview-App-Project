//
//  ParametersConvertible.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/16/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

protocol ParametersConvertible {
    var parameters: [String: Any] { get }
}
