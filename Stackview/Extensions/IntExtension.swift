//
//  IntExtension.swift
//  Stackview
//
//  Created by Sergiy Momot on 10/5/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

extension Int {
    func toString() -> String {
        var number = ""
        var count = 0
        
        for char in String(self).reversed() {
            if count == 3 {
                number += ","
                count = 0
            }
            
            number += String(char)
            count += 1
        }
        
        return String(number.reversed())
    }
    
    func toShortString() -> String {
        switch abs(self) {
        case 0..<1000:
            return String(self)
            
        case 1000..<1000000:
            let value = Double(self) / 1000.0
            return String(format: value < 100.0 ? "%.1f" : "%.0f", value) + "K"
            
        default:
            let value = Double(self) / 1000000.0
            return String(format: value < 100.0 ? "%.1f" : "%.0f", value) + "M"
        }
    }
}
