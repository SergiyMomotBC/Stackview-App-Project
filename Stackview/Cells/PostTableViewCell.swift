//
//  PostTableViewCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/13/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class PostTableViewCell: GenericCell<Post> {
    @IBOutlet weak var postTypeLabel: UILabel!
    @IBOutlet weak var postedDateLabel: UILabel!
    @IBOutlet weak var scoreLabel: ScoreLabel!
    @IBOutlet weak var postTitleLabel: UILabel!

    override func setup(for post: Post) {
        if let type = post.type {
            postTypeLabel.text = type == .question ? "Question" : "Answer"
            postedDateLabel.text = post.creationDate!.getCreationTimeText()
            scoreLabel.text = (post.score ?? 0).toString()
            scoreLabel.isAccepted = false
            postTitleLabel.text = post.title?.htmlUnescape()
        }
    }
}
