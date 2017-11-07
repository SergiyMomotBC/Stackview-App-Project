//
//  MenuItemCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/21/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var menuItemLabel: UILabel!
    
    private static let selectedColor = UIColor.flatRed
    private static let unselectedColor = UIColor.white
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        menuItemLabel.textColor = MenuItemCell.unselectedColor
        iconImageView.tintColor = MenuItemCell.unselectedColor
        
        if UIScreen.main.bounds.width <= 320 {
            menuItemLabel.font = UIFont.systemFont(ofSize: 18.0)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        menuItemLabel.textColor = selected ? MenuItemCell.selectedColor : MenuItemCell.unselectedColor
        iconImageView.tintColor = selected ? MenuItemCell.selectedColor : MenuItemCell.unselectedColor
    }
}
