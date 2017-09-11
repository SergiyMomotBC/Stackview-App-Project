//
//  BountyLabel.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/25/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class PaddedLabel: UILabel {
    let insets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, self.insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height += insets.top + insets.bottom
        size.width += insets.left + insets.right
        return size
    }
}
