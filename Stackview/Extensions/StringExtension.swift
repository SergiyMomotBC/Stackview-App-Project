//
//  StringExtension.swift
//  Stackview
//
//  Created by Sergiy Momot on 10/24/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

extension String {
    func removingHREF() -> String {
        var text = self
        
        if let range = text.range(of: "(?i)<a([^>]+)>", options: .regularExpression) {
            text.removeSubrange(range)
        }
        
        if let range = text.range(of: "</a>") {
            text.removeSubrange(range)
        }
        
        return text
    }
}
