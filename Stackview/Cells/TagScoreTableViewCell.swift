//
//  TagScoreTableViewCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/18/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class TagScoreTableViewCell: GenericCell<TagScore> {
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var userInfoLabel: UserInfoLabel!
    @IBOutlet weak var badgeCountsView: BadgesView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var postsLabel: ScoreLabel!
    
    override func setup(for tagScore: TagScore) {
        profileImageView.setUser(tagScore.user)
        userInfoLabel.setInfo(username: tagScore.user?.name, reputation: tagScore.user?.reputation, type: tagScore.user?.type)
        badgeCountsView.setup(for: tagScore.user!.badgeCounts!)
        
        let score = tagScore.score ?? 0
        scoreLabel.emphasize(text: "\(score.toString()) score")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView?.image = nil
    }
}
