//
//  TopTagTableViewCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/12/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class TopTagTableViewCell: GenericCell<TopTag> {
    @IBOutlet weak var tagNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    override func setup(for tag: TopTag) {
        tagNameLabel.text = tag.tagName

        let score = tag.answerScore ?? 0
        scoreLabel.emphasize(text: "\(score.toString()) score")
        
        let count = (tag.answersCount ?? 0) + (tag.questionsCount ?? 0)
        postsLabel.emphasize(text: "\(count.toString()) \(abs(count) == 1 ? "post" : "posts")")
    }
}
