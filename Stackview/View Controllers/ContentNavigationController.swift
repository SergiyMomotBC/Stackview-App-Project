//
//  ContentNavigationController.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/21/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import InteractiveSideMenu

class ContentNavigationController: UINavigationController, SideMenuItemContent {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuBarButton = UIBarButtonItem(image: UIImage(named: "menu_icon")!.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(menuButtonTapped))
        navigationBar.topItem?.leftBarButtonItem = menuBarButton
        
        navigationBar.tintColor = .white
        navigationBar.barTintColor = .mainAppColor
        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationBar.shadowImage = UIImage()
    }
    
    @objc private func menuButtonTapped() {
        showSideMenu()
    }
}
