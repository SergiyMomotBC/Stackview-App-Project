//
//  GenericCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/7/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import HTMLEntities

class GenericCell<T>: UITableViewCell {
    func setup(for: T) {}
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                self.alpha = 0.5
            }, completion: { success in
                if success {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.transform = .identity
                        self.alpha = 1.0
                    })
                }
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentView.subviews.first?.layer.cornerRadius = 6.0
    }
}
