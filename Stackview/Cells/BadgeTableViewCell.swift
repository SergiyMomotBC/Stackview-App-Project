//
//  BadgeTableViewCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/1/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class BadgeTableViewCell: GenericCell<Badge> {
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var container: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        container.clipsToBounds = true
        container.layer.cornerRadius = 6.0
        contentView.subviews.first?.layer.cornerRadius = 6.0
    }
    
    override func setup(for badge: Badge) {
        nameLabel.text = badge.name
        countLabel.text = "x\(badge.awardCount ?? 0)"
        descriptionLabel.text = badge.description?.htmlUnescape()
        
        if let type = badge.rank {
            switch type {
            case .gold:
                badgeImageView.image = UIImage(named: "gold_badge")
            case .silver:
                badgeImageView.image = UIImage(named: "silver_badge")
            case .bronze:
                badgeImageView.image = UIImage(named: "bronze_badge")
            }
        }
        
        containerWidthConstraint.constant = 24 + badgeImageView.frame.width + (nameLabel.text! as NSString).size(withAttributes: [.font: nameLabel.font]).width
    }
}
