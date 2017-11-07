//
//  ScoreLabel.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/18/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class ScoreLabel: PaddedLabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        layer.cornerRadius = 6.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.greenAcceptedColor.cgColor
        textAlignment = .center
        clipsToBounds = true
        font = UIFont.systemFont(ofSize: 16.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    var isAccepted: Bool = false {
        didSet {
            if isAccepted {
                backgroundColor = UIColor.greenAcceptedColor
                textColor = UIColor.white
            } else {
                backgroundColor = .clear
                textColor = UIColor.greenAcceptedColor
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let ics = super.intrinsicContentSize
        return CGSize(width: ics.width > 55 ? ics.width : 55, height: ics.height)
    }
}
