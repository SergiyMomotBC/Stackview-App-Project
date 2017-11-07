//
//  UserProfileTableViewCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/15/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class UserProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var questionsLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var profileViewsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var memberForLabel: UILabel!
    @IBOutlet weak var lastSeenLabel: UILabel!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var websiteView: UIView!
    @IBOutlet weak var extraInfoStackView: UIStackView!
    @IBOutlet weak var topSeparatorView: UIView!
    
    lazy var aboutWebView = PostWebView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentView.subviews.first!.layer.cornerRadius = 6.0
        
        aboutWebView.scrollView.alwaysBounceVertical = false
        aboutWebView.scrollView.showsVerticalScrollIndicator = true
        webViewContainer.addSubview(aboutWebView)
        aboutWebView.topAnchor.constraint(equalTo: webViewContainer.topAnchor).isActive = true
        aboutWebView.leadingAnchor.constraint(equalTo: webViewContainer.leadingAnchor).isActive = true
        aboutWebView.trailingAnchor.constraint(equalTo: webViewContainer.trailingAnchor).isActive = true
        aboutWebView.bottomAnchor.constraint(equalTo: webViewContainer.bottomAnchor).isActive = true
    }
    
    func setup(for user: User) {
        questionsLabel.numberOfLines = 2
        let qCount = user.questionsCount ?? 0
        questionsLabel.emphasize(text: "\(qCount.toString())\n\(qCount == 1 ? "Question" : "Questions")", separator: "\n")
        
        answersLabel.numberOfLines = 2
        let aCount = user.answersCount ?? 0
        answersLabel.emphasize(text: "\(aCount.toString())\n\(aCount == 1 ? "Answer" : "Answers")", separator: "\n")
        
        profileViewsLabel.numberOfLines = 2
        let vCount = user.viewsCount ?? 0
        profileViewsLabel.emphasize(text: "\(vCount.toShortString())\nProfile \(vCount == 1 ? "view" : "views")", separator: "\n")
        
        let components = Calendar.current.dateComponents([.year, .month, .day], from: user.creationDate!, to: Date())
        let years = components.year!
        let months = components.month!
        let days = components.day!
        
        var text: String
        if years > 0 {
            text = "for \(years) \(years == 1 ? "year" : "years")"
            if months > 0 {
                text += ", \(months) \(months == 1 ? "month" : "months")"
            }
        } else if months > 0 {
            text = "for \(months) \(months == 1 ? "month" : "months")"
            if days > 0 {
                text += ", \(days) \(days == 1 ? "day" : "days")"
            }
        } else if days > 0 {
            text = "for \(days) \(days == 1 ? "day" : "days")"
        } else {
            text = "since today"
        }
        
        memberForLabel.text = "Member " + text
        lastSeenLabel.text = "Last seen " + (user.lastAccessDate?.getCreationTimeText() ?? "...")
        
        if let location = user.location, !location.isEmpty {
            locationLabel.text = location
        } else {
            extraInfoStackView.removeArrangedSubview(locationView)
            locationView.removeFromSuperview()
        }
        
        if let website = user.websiteURL, !website.isEmpty {
            websiteLabel.text = website
        } else {
            extraInfoStackView.removeArrangedSubview(websiteView)
            websiteView.removeFromSuperview()
        }
        
        if let aboutMe = user.aboutMeText, !aboutMe.isEmpty {
            aboutWebView.loadHTML(string: aboutMe)
        } else {
            topSeparatorView.removeFromSuperview()
            webViewContainer.removeFromSuperview()
        }
    }
}
