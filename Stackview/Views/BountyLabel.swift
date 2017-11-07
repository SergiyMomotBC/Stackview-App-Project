//
//  BountyLabel.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/24/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class BountyLabel: PaddedLabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        textColor = .white
        layer.cornerRadius = 6.0
        clipsToBounds = true
        backgroundColor = .bountyColor
        font = UIFont.systemFont(ofSize: 16.0)
    }
    
    func setBounty(_ amount: Int) {
        text = "+\(amount)"
    }
}
