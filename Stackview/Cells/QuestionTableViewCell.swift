//
//  QuestionTableViewCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/22/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import Kingfisher

class QuestionTableViewCell: GenericCell<Question> {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postedDateLabel: UILabel!
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var tagsCollectionView: TagsCollectionView!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var answersCountLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var bountyAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        bountyAmountLabel.layer.cornerRadius = 6.0
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        profileImageView.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        profileImageView.layer.borderWidth = 1.0
        
        self.contentView.subviews.first?.layer.cornerRadius = 6.0
        
        questionTitleLabel.textColor = .secondaryAppColor
    }
    
    override func setup(for question: Question) {
        if let imageURL = question.owner?.profileImageURL {
            profileImageView.kf.setImage(with: imageURL)
        }

        usernameLabel.text = question.owner?.name?.htmlUnescape()
        questionTitleLabel.text = question.title?.htmlUnescape()

        if let creationDate = question.creationDate {
            postedDateLabel.text = CellUtils.getCreationTimeText(for: creationDate)
        } else {
            postedDateLabel.text = ""
        }

        tagsCollectionView.tagNames = question.tags ?? []

        CellUtils.setCountLabelAttributes(label: votesLabel, number: question.score ?? 0, word: "vote")
        CellUtils.setCountLabelAttributes(label: answersCountLabel, number: question.answersCount ?? 0, word: "answer")
        CellUtils.setCountLabelAttributes(label: viewsCountLabel, number: question.viewsCount ?? 0, word: "view")

        answersCountLabel.backgroundColor = ((question.acceptedAnswerID ?? 0) > 0) ? CellUtils.hasAcceptedAnswerColor : .clear

        if question.acceptedAnswerID != nil {
            let answers = NSMutableAttributedString(attributedString: answersCountLabel.attributedText!)
            answers.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: answers.length))
            answersCountLabel.attributedText = answers
        }

        if let bountyAmount = question.bountyAmount {
            bountyAmountLabel.text = "+\(bountyAmount)"
            bountyAmountLabel.isHidden = false
        } else {
            bountyAmountLabel.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }
}


