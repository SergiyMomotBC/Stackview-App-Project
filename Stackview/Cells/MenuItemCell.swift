//
//  MenuItemCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/21/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {
    @IBOutlet weak var selectionIndicatorView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var menuItemLabel: UILabel!
    
    private static let selectedColor = UIColor(red: 1.0, green: 153 / 255.0, blue: 0.0, alpha: 1.0)
    private static let unselectedColor = UIColor(red: 208 / 255.0, green: 210 / 255.0, blue: 212 / 255.0, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        menuItemLabel.textColor = MenuItemCell.unselectedColor
        iconImageView.tintColor = MenuItemCell.unselectedColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectionIndicatorView.backgroundColor = selected ? MenuItemCell.selectedColor : .clear
        menuItemLabel.textColor = selected ? MenuItemCell.selectedColor : MenuItemCell.unselectedColor
        iconImageView.tintColor = selected ? MenuItemCell.selectedColor : MenuItemCell.unselectedColor
    }
}
