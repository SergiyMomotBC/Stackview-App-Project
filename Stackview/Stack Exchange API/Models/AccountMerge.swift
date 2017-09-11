//
//  MergeHistory.swift
//  Stack Exchange API Swift
//
//  Created by Sergiy Momot on 8/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

struct AccountMerge: Decodable {
    let date: Date?
    let newAccountID: Int?
    let oldAccountID: Int?
    
    private enum CodingKeys: String, CodingKey {
        case date = "merge_date"
        case newAccountID = "new_account_id"
        case oldAccountID = "old_account_id"
    }
}
