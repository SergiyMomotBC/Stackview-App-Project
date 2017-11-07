//
//  QuestionTableViewCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/22/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class QuestionTableViewCell: GenericCell<Question> {
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var usernameLabel: UserInfoLabel!
    @IBOutlet weak var postedDateLabel: UILabel!
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var tagsCollectionView: TagsCollectionView!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var answersCountLabel: ScoreLabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var bountyAmountLabel: BountyLabel!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    override func setup(for question: Question) {
        profileImageView.setUser(question.owner)

        usernameLabel.setInfo(username: question.owner?.name, reputation: question.owner?.reputation, type: question.owner?.type)
        questionTitleLabel.text = question.title?.htmlUnescape()

        if let creationDate = question.creationDate {
            postedDateLabel.text = creationDate.getCreationTimeText()
        } else {
            postedDateLabel.text = ""
        }

        DispatchQueue.main.async {
            self.tagsCollectionView.tagNames = question.tags ?? []
        }
        
        let qScore = question.score ?? 0
        votesLabel.emphasize(text: "\(qScore.toShortString()) \(abs(qScore) == 1 ? "vote" : "votes")")
        
        let aCount = question.answersCount ?? 0
        answersCountLabel.emphasize(text: "\(aCount.toShortString()) \(abs(aCount) == 1 ? "answer" : "answers")")
        
        let vCount = question.viewsCount ?? 0
        viewsCountLabel.emphasize(text: "\(vCount.toShortString()) \(abs(vCount) == 1 ? "view" : "views")")
        
        answersCountLabel.backgroundColor = ((question.acceptedAnswerID ?? 0) > 0) ? .greenAcceptedColor : .clear

        answersCountLabel.isAccepted = question.acceptedAnswerID != nil

        if let bountyAmount = question.bountyAmount {
            bountyAmountLabel.setBounty(bountyAmount)
            bountyAmountLabel.isHidden = false
        } else {
            bountyAmountLabel.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView?.image = nil
    }
}
