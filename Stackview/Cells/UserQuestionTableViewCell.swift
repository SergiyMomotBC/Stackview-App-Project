//
//  UserQuestionTableViewCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/15/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class UserQuestionTableViewCell: GenericCell<Question> {
    @IBOutlet weak var postedDateLabel: UILabel!
    @IBOutlet weak var bountyAmountLabel: BountyLabel!
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var tagsCollectionView: TagsCollectionView!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var answersCountLabel: ScoreLabel!
    @IBOutlet weak var viewsCountLabel: UILabel!

    override func setup(for question: Question) {
        questionTitleLabel.text = question.title?.htmlUnescape()
        
        if let creationDate = question.creationDate {
            postedDateLabel.text = "Asked " + creationDate.getCreationTimeText()
        } else {
            postedDateLabel.text = ""
        }
        
        DispatchQueue.main.async {
            self.tagsCollectionView.tagNames = question.tags ?? []
        }
        
        let qScore = question.score ?? 0
        votesLabel.emphasize(text: "\(qScore.toString()) \(abs(qScore) == 1 ? "vote" : "votes")")
        
        let aCount = question.answersCount ?? 0
        answersCountLabel.emphasize(text: "\(aCount.toString()) \(abs(aCount) == 1 ? "answer" : "answers")")
        answersCountLabel.isAccepted = question.acceptedAnswerID != nil
        
        let vCount = question.viewsCount ?? 0
        viewsCountLabel.emphasize(text: "\(vCount.toShortString()) \(abs(vCount) == 1 ? "view" : "views")")
        
        answersCountLabel.backgroundColor = ((question.acceptedAnswerID ?? 0) > 0) ? .greenAcceptedColor : .clear
        
        if question.acceptedAnswerID != nil {
            let answers = NSMutableAttributedString(attributedString: answersCountLabel.attributedText!)
            answers.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: answers.length))
            answersCountLabel.attributedText = answers
        }
        
        if let bountyAmount = question.bountyAmount {
            bountyAmountLabel.setBounty(bountyAmount)
            bountyAmountLabel.isHidden = false
        } else {
            bountyAmountLabel.isHidden = true
        }
    }
}
