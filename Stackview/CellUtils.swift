//
//  Utils.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/28/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation
import UIKit

class CellUtils {
    static let hasAcceptedAnswerColor = UIColor(red: 99 / 255.0, green: 186 / 255.0, blue: 129 / 255.0, alpha: 1.0)
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, y"
        return formatter
    }()
    
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "j:mm", options: 0, locale: Locale.current)
        return formatter
    }()
    
    static func getCreationTimeText(for date: Date) -> String {
        let seconds = Calendar.current.dateComponents([.second], from: date, to: Date()).second!
        
        if seconds == 0 {
            return "Just now"
        } else if seconds < 60 {
            return "\(seconds) \(seconds == 1 ? "second" : "seconds") ago"
        } else if seconds < 3600 {
            return "\(seconds / 60) \(seconds / 60 == 1 ? "minute" : "minutes") ago"
        } else if seconds < 24 * 3600 {
            return "\(seconds / 3600) \(seconds / 3600 == 1 ? "hour" : "hours") ago"
        } else {
            return "on " + CellUtils.dateFormatter.string(from: date) + " at " + CellUtils.timeFormatter.string(from: date)
        }
    }
    
    static func setCountLabelAttributes(label: UILabel, number: Int, word: String) {
        let text = "\(number) \(abs(number) == 1 ? word : word + "s")"
        let index = text.index(of: " ")!.encodedOffset
        let string = NSMutableAttributedString(string: text)
        string.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18.0),
                              NSAttributedStringKey.foregroundColor: UIColor.darkGray], range: NSRange(location: 0, length: index))
        string.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0),
                              NSAttributedStringKey.foregroundColor: UIColor.lightGray], range: NSRange(location: index + 1, length: text.characters.count - index - 1))
        label.attributedText = string
    }
}
