//
//  FloatingButton.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/31/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class FloatingButton: UIButton {
    let size: CGFloat = 50.0
    
    init(image: UIImage) {
        super.init(frame: .zero)
        
        tintColor = .white
        setImage(image, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: size).isActive = true
        heightAnchor.constraint(equalToConstant: size).isActive = true
        layer.cornerRadius = size / 2
        backgroundColor = UIColor.flatBlack
        alpha = 0.9
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
