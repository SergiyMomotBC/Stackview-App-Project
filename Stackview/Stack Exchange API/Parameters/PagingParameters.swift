//
//  PagingParameters.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/16/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct PagingParameters: ParametersConvertible {
    private let pageSizeParameterName = "pagesize"
    private let pageNumberParameterName = "page"
    private let maxPageSize = 100
    private let minPageSize = 0
    private let minPageNumber = 1
    
    let pageSize: Int
    var pageNumber: Int
    
    init(pageSize: Int) {
        self.pageSize = max(min(pageSize, maxPageSize), minPageSize)
        self.pageNumber = minPageNumber
    }
    
    init(pageNumber: Int, pageSize: Int) {
        self.pageNumber = max(pageNumber, minPageNumber)
        self.pageSize = max(min(pageSize, maxPageSize), minPageSize)
    }
    
    mutating func nextPage() {
        self.pageNumber += 1
    }
    
    mutating func reset() {
        self.pageNumber = 1
    }
    
    var parameters: [String: Any] {
        return [pageNumberParameterName: pageNumber, pageSizeParameterName: pageSize]
    }
}
