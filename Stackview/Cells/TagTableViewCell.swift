//
//  TagTableViewCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/31/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class TagTableViewCell: GenericCell<Tag> {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    private var tagName: String?
    
    override func setup(for tag: Tag) {
        tagName = tag.name
        nameLabel.text = tag.name?.htmlUnescape()
        countLabel.text = "x\((tag.count ?? 0).toString())"
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        if let tag = tagName {
            TagQuickInfoPopupController.displayQuickInfo(about: tag)
        }
    }
}
