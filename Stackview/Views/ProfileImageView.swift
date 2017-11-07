//
//  ProfileImageView.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/19/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileImageView: UIImageView {
    private var userID: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        isUserInteractionEnabled = true
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        backgroundColor = .lightGray
        clipsToBounds = true
        contentMode = .scaleAspectFit
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(wasTapped))
        tapRecognizer.numberOfTapsRequired = 1
        addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func wasTapped() {
        if let userid = self.userID {
            MainViewController.topViewController?.navigationController?.show(UserProfileViewController(for: String(userid)), sender: nil)
        }
    }
    
    func setUser(_ user: ShallowUser?) {
        if let u = user {
            userID = u.id
            kf.setImage(with: u.profileImageURL)
        }
    }
    
    func setUser(_ user: User?) {
        if let u = user {
            userID = u.id
            kf.setImage(with: u.profileImageURL)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}
