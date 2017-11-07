//
//  MainNavigationBar.swift
//  Stackview
//
//  Created by Sergiy Momot on 10/17/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class MainNavigationBar: UINavigationBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let image = UIImage(named: "back_button")!.withRenderingMode(.alwaysTemplate)
        backIndicatorImage = image
        backIndicatorTransitionMaskImage = image
        
        tintColor = .white
        barTintColor = .mainAppColor
        isTranslucent = false
        titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 20.0)]
        shadowImage = UIImage()
        setBackgroundImage(UIImage(), for: .default)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

