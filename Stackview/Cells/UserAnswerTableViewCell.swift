//
//  UserAnswerTableViewCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/15/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class UserAnswerTableViewCell: GenericCell<Answer> {
    @IBOutlet weak var postedDateLabel: UILabel!
    @IBOutlet weak var scoreLabel: ScoreLabel!
    @IBOutlet weak var questionTitleLabel: UILabel!

    override func setup(for answer: Answer) {
        postedDateLabel.text = "Answered " + answer.creationDate!.getCreationTimeText()
        scoreLabel.text = (answer.score ?? 0).toString()
        scoreLabel.isAccepted = answer.isAccepted ?? false
        questionTitleLabel.text = answer.title?.htmlUnescape()
    }
}
