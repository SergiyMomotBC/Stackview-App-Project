//
//  BadgesView.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/11/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class BadgesView: UIStackView {
    var textColor: UIColor = .white {
        didSet {
            goldBadgesLabel.textColor = textColor
            silverBadgesLabel.textColor = textColor
            bronzeBadgesLabel.textColor = textColor
        }
    }
    
    var goldBadgesLabel: UILabel!
    var silverBadgesLabel: UILabel!
    var bronzeBadgesLabel: UILabel!
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        distribution = .fillEqually
        alignment = .center
        axis = .horizontal
        spacing = 4.0
        
        goldBadgesLabel = addBadgeItem(image: UIImage(named: "gold_badge")!)
        silverBadgesLabel = addBadgeItem(image: UIImage(named: "silver_badge")!)
        bronzeBadgesLabel = addBadgeItem(image: UIImage(named: "bronze_badge")!)
    }
    
    func setup(for badges: BadgeCount) {
        goldBadgesLabel.text = String(badges.gold ?? 0)
        silverBadgesLabel.text = String(badges.silver ?? 0)
        bronzeBadgesLabel.text = String(badges.bronze ?? 0)
    }
    
    private func addBadgeItem(image: UIImage) -> UILabel {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        
        container.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.numberOfLines = 1
        label.textAlignment = .left
        
        container.addSubview(label)
        label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4.0).isActive = true
        label.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
        addArrangedSubview(container)
        
        return label
    }
}
