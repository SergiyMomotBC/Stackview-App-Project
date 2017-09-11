//
//  GenericCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/7/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

class GenericCell<T: Decodable>: UITableViewCell {
    func setup(for: T) {}
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
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
}
