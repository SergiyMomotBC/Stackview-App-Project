//
//  NotificationTableViewCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 10/17/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class NotificationTableViewCell: GenericCell<Notification> {
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    
    override func setup(for notification: Notification) {
        bodyLabel.text = notification.bodyText?.htmlUnescape().removingHREF()
        creationDateLabel.text = notification.creationDate?.getCreationTimeText()
    }
}
