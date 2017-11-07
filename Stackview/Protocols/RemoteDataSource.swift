//
//  SearchViewControllerDelegate.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/31/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

protocol RemoteDataSource: class {
    var endpoint: String { get }
    var parameters: [ParametersConvertible] { get }
}
