//
//  BrowsingRecordTableViewCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/28/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class BrowsingRecordTableViewCell: GenericCell<BrowsingRecord> {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagsCollectionView: TagsCollectionView!

    override func setup(for record: BrowsingRecord) {
        titleLabel.text = record.title?.htmlUnescape()
        
        DispatchQueue.main.async {
            self.tagsCollectionView.tagNames = NSKeyedUnarchiver.unarchiveObject(with: record.tagsData! as Data) as! [String]
        }
    }
}
