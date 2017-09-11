//
//  UserTableViewCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/11/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class UserTableViewCell: GenericCell<User> {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var badgesCountView: BadgesView!
    
    let nameAttributes: [NSAttributedStringKey: Any] = [.font: UIFont.boldSystemFont(ofSize: 16.0), .foregroundColor: UIColor.secondaryAppColor]
    let reputationAttributes: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 14.0), .foregroundColor: UIColor.lightGray]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        contentView.subviews.first!.layer.cornerRadius = 6.0
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        profileImageView.layer.borderWidth = 1.0
        profileImageView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
    }

    override func setup(for user: User) {
        if let imageURL = user.profileImageURL {
            profileImageView.kf.setImage(with: imageURL)
        }
        
        let text = NSMutableAttributedString(string: user.name ?? "", attributes: nameAttributes)
        text.append(NSAttributedString(string: " • "))
        text.append(NSAttributedString(string: String(user.reputation ?? 0), attributes: reputationAttributes))
        userInfoLabel.attributedText = text
        
        badgesCountView.setup(for: user.badgeCounts!)
    }
}
