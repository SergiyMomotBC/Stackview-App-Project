//
//  UserTableViewCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/11/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class UserTableViewCell: GenericCell<User> {
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var userInfoLabel: UserInfoLabel!
    @IBOutlet weak var badgesCountView: BadgesView!

    override func setup(for user: User) {
        profileImageView.setUser(user)
        userInfoLabel.setInfo(username: user.name, reputation: user.reputation, type: user.type)
        badgesCountView.setup(for: user.badgeCounts!)
    }
}
