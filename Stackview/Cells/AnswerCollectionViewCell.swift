//
//  AnswerCollectionViewCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/21/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class AnswerCollectionViewCell: UICollectionViewCell {
    let editorViewHeight: CGFloat = 30.0
    
    @IBOutlet weak var userInfoLabel: UserInfoLabel!
    @IBOutlet weak var postedDateLabel: UILabel!
    @IBOutlet weak var scoreLabel: ScoreLabel!
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var editorProfileImageView: ProfileImageView!
    @IBOutlet weak var editorProfileImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var editorInfoLabel: UserInfoLabel!
    @IBOutlet weak var editedDateLabel: UILabel!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var editorViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomSeparatorView: UIView!
    @IBOutlet weak var bountyLabel: BountyLabel!
    
    let bodyWebView = PostWebView()
    weak var delegate: AnswersCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        contentView.subviews.first!.layer.cornerRadius = 6.0
        contentView.subviews.first!.layer.borderWidth = 2.0
        contentView.backgroundColor = .clear
        contentView.subviews.first!.clipsToBounds = true
        commentsButton.addTarget(self, action: #selector(didTapCommentsButton(_:)), for: .touchUpInside)
        
        containerView.addSubview(bodyWebView)
        bodyWebView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        bodyWebView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        bodyWebView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        bodyWebView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }

    func setup(for answer: Answer) {
        profileImageView.setUser(answer.owner)
        userInfoLabel.setInfo(username: answer.owner?.name, reputation: answer.owner?.reputation, type: answer.owner?.type)
        postedDateLabel.text = answer.creationDate!.getCreationTimeText()
        scoreLabel.text = (answer.score ?? 0).toString()
        scoreLabel.isAccepted = answer.isAccepted ?? false

        bodyWebView.loadHTML(string: answer.bodyText!)
        
        commentsButton.setTitle("Show comments (\(answer.commentsCount ?? 0))", for: .normal)
        
        if answer.lastEditor != nil || answer.awardedBountyAmount != nil {
            editorViewHeightConstraint.constant = editorViewHeight
            bottomSeparatorView.isHidden = false
        } else {
            editorViewHeightConstraint.constant = 0.0
            bottomSeparatorView.isHidden = true
        }
        
        if let editor = answer.lastEditor, let editDate = answer.lastEditDate {
            editedDateLabel.text = "Edited " + editDate.getCreationTimeText(shortForm: true)
            
            if (editor.id ?? -1) != (answer.owner!.id ?? -2) {
                editorProfileImageView.setUser(editor)
                editedDateLabel.font = UIFont.systemFont(ofSize: 12.0)
                editorInfoLabel.isHidden = false
                editorInfoLabel.setInfo(username: editor.name, reputation: editor.reputation, type: editor.type)
                editorProfileImageView.isHidden = false
            } else {
                editorInfoLabel.isHidden = true
                editedDateLabel.font = UIFont.systemFont(ofSize: 14.0)
                editorProfileImageView.isHidden = true
            }
        }
        
        if let bountyAmount = answer.awardedBountyAmount {
            bountyLabel.isHidden = false
            bountyLabel.setBounty(bountyAmount)
        } else {
            bountyLabel.isHidden = true
        }
        
        contentView.subviews.first!.layer.borderColor = (answer.isAccepted ?? false) ? UIColor.greenAcceptedColor.cgColor : UIColor.clear.cgColor
    }
    
    @objc private func didTapCommentsButton(_ sender: UIButton) {
        delegate?.commentsButtonWasTapped(sender)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }
}
