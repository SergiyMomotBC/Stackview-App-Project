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
    private var tagObject: Tag?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentView.subviews.first!.layer.cornerRadius = 6.0
    }
    
    override func setup(for tag: Tag) {
        self.tagObject = tag
        nameLabel.text = tag.name?.htmlUnescape()
        countLabel.text = "x\(tag.count ?? 0)"
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        if let tag = self.tagObject {
            TagQuickInfoPopupController.displayQuickInfo(about: tag.name!)
        }
    }
}
