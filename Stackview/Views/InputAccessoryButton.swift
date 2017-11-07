//
//  InputAccessoryButton.swift
//  Stackview
//
//  Created by Sergiy Momot on 10/8/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class InputAccessoryButton: UIVisualEffectView {
    private let button: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        return button
    }()
    
    private let action: () -> Void
    
    init(title: String, action: @escaping () -> Void) {
        self.action = action
        super.init(effect: UIBlurEffect(style: .dark))
        frame = CGRect(x: 0, y: 0, width: 0, height: 40)
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setTitle(title, for: .normal)
        contentView.addSubview(button)
        button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        action()
    }
}
