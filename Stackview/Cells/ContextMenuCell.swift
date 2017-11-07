//
//  ContextMenuCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 10/10/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class ContextMenuCell: GenericCell<ContextMenuItem> {
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconImageView.contentMode = .center
        iconImageView.tintColor = .white
        titleLable.textColor = .white
    }
    
    override func setup(for item: ContextMenuItem) {
        titleLable.text = item.title
        iconImageView.image = item.icon.withRenderingMode(.alwaysTemplate)
    }
}
