//
//  QuestionStatusView.swift
//  Stackview
//
//  Created by Sergiy Momot on 10/13/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class QuestionStatusView: UIStackView {
    private let height: CGFloat = 32.0
    private let question: Question
    
    init(for question: Question) {
        self.question = question
        super.init(frame: .zero)
        
        axis = .vertical
        distribution = .fill
        alignment = .center
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        var title: String
        var subtitle: String?
        
        if question.closedDate != nil, let closeDetails = question.closedDetails {
            title = closeDetails.isOnHold! ? "On hold" : "Closed"
            subtitle = closeDetails.reason
        } else if let locked = question.lockedDate {
            title = "Locked"
            subtitle = locked.getCreationTimeText()
        } else if let protected = question.protectedDate {
            title = "Protected"
            subtitle = protected.getCreationTimeText()
        } else if question.acceptedAnswerID != nil {
            title = "Answered"
        } else {
            title = "Unanswered"
        }
        
        let titleLabel = createLabel(text: title, color: .white, font: .systemFont(ofSize: 18.0))
        var maxWidth = titleLabel.intrinsicContentSize.width
        addArrangedSubview(titleLabel)
        
        if let subtitle = subtitle {
            let subtitleLabel = createLabel(text: subtitle, color: UIColor(white: 0.85, alpha: 1.0), font: .systemFont(ofSize: 12.0))
            maxWidth = max(maxWidth, subtitleLabel.intrinsicContentSize.width)
            addArrangedSubview(subtitleLabel)
            titleLabel.font = .systemFont(ofSize: 16.0)
        }
        
        maxWidth += 8.0
        
        if #available(iOS 11.0, *) {
            translatesAutoresizingMaskIntoConstraints = false
            widthAnchor.constraint(equalToConstant: maxWidth).isActive = true
            heightAnchor.constraint(equalToConstant: height).isActive = true
        } else {
            frame = CGRect(x: 0, y: 0, width: maxWidth, height: height)
        }
    }
    
    private func createLabel(text: String, color: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        label.text = text
        label.textColor = color
        label.font = font
        return label
    }
}
