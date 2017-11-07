//
//  ContentNavigationController.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/21/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class ContentNavigationController: UINavigationController, SideMenuItemContent {
    init() {
        super.init(navigationBarClass: MainNavigationBar.self, toolbarClass: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainAppColor
        
        let menuBarButton = UIBarButtonItem(image: UIImage(named: "menu_icon")!.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(menuButtonTapped))
        navigationBar.topItem?.leftBarButtonItem = menuBarButton
    }
    
    override func show(_ vc: UIViewController, sender: Any?) {
        topViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        super.show(vc, sender: nil)
    }
    
    @objc private func menuButtonTapped() {
        showSideMenu()
    }
}
