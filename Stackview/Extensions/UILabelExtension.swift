//
//  UILabelExtension.swift
//  Stackview
//
//  Created by Sergiy Momot on 10/5/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

extension UILabel {
    func emphasize(text: String, separator: Character = " ") {
        guard let index = text.index(of: separator)?.encodedOffset else {
            return
        }
        
        let string = NSMutableAttributedString(string: text)
        string.addAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16.0),
                              NSAttributedStringKey.foregroundColor: UIColor.flatBlack], range: NSRange(location: 0, length: index))
        string.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0),
                              NSAttributedStringKey.foregroundColor: UIColor.lightGray], range: NSRange(location: index + 1, length: text.count - index - 1))
        self.attributedText = string
    }
}

