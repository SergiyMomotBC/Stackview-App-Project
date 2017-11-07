//
//  DateExtension.swift
//  Stackview
//
//  Created by Sergiy Momot on 10/5/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

fileprivate let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, y"
    return formatter
}()

fileprivate let shortDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/y"
    return formatter
}()

fileprivate let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "H:mm"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}()

extension Date {
    func getExpiresTimeText() -> String {
        let seconds = Calendar.current.dateComponents([.second], from: Date(), to: self).second!
        
        if seconds == 0 {
            return "now"
        } else if seconds < 60 {
            return "in \(seconds) \(seconds == 1 ? "second" : "seconds")"
        } else if seconds < 3600 {
            return "in \(seconds / 60) \(seconds / 60 == 1 ? "minute" : "minutes")"
        } else if seconds < 24 * 3600 {
            return "in \(seconds / 3600) \(seconds / 3600 == 1 ? "hour" : "hours")"
        } else {
            return "on " + dateFormatter.string(from: self) + " at " + timeFormatter.string(from: self)
        }
    }
    
    func getCreationTimeText(shortForm: Bool = false) -> String {
        let seconds = Calendar.current.dateComponents([.second], from: self, to: Date()).second!
        
        if seconds == 0 {
            return "just now"
        } else if seconds < 60 {
            return "\(seconds) \(seconds == 1 ? "second" : "seconds") ago"
        } else if seconds < 3600 {
            return "\(seconds / 60) \(seconds / 60 == 1 ? "minute" : "minutes") ago"
        } else if seconds < 24 * 3600 {
            return "\(seconds / 3600) \(seconds / 3600 == 1 ? "hour" : "hours") ago"
        } else {
            if shortForm {
                return "on " + shortDateFormatter.string(from: self)
            } else {
                return "on " + dateFormatter.string(from: self) + " at " + timeFormatter.string(from: self)
            }
        }
    }
}
