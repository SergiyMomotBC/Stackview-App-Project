//
//  TagCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/22/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    private let cellBackgroundColor = UIColor.flatRed
    
    let tagNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = cellBackgroundColor
        contentView.layer.cornerRadius = 6.0
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(tagNameLabel)
        tagNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        tagNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        tagNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        tagNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
