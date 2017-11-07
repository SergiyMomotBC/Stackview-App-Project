//
//  UserInfoLabel.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/19/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class UserInfoLabel: UILabel {
    let nameAttributes: [NSAttributedStringKey: Any] = [.font: UIFont.boldSystemFont(ofSize: 16.0), .foregroundColor: UIColor.flatBlack]
    let reputationAttributes: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 12.0), .foregroundColor: UIColor.lightGray]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
    }
    
    func setInfo(username: String?, reputation: Int?, type: UserType?) {
        let name = (username ?? "Unknown").htmlUnescape() + (type == .moderator ? "♦︎" : "")
        let text = NSMutableAttributedString(string: name, attributes: nameAttributes)
        text.append(NSAttributedString(string: "  "))
        text.append(NSAttributedString(string: (reputation ?? 0).toString(), attributes: reputationAttributes))
        attributedText = text
    }
}
