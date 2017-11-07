//
//  InboxItemTableViewCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 10/17/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class InboxItemTableViewCell: GenericCell<InboxItem> {
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    
    override func setup(for inboxItem: InboxItem) {
        typeLabel.text = inboxItem.type?.replacingOccurrences(of: "_", with: " ").capitalized ?? "Unknown type"
        titleLabel.text = inboxItem.title?.htmlUnescape()
        bodyLabel.text = inboxItem.bodyText ?? "No additional information."
        creationDateLabel.text = inboxItem.creationDate?.getCreationTimeText()
    }
}
