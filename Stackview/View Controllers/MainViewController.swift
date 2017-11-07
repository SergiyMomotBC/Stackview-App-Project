//
//  MainViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/21/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class MainViewController: MenuContainerViewController {
    static var topViewController: UIViewController? {
        guard let mainVC = UIApplication.shared.keyWindow?.rootViewController as? MainViewController else {
            return nil
        }
        
        if let menuVC = mainVC.menuViewController as? SideMenuViewController, menuVC.isPresented {
            return menuVC
        } else {
            return (mainVC.currentContentViewController as? UINavigationController)?.topViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitionOptions = TransitionOptions(duration: 0.33, visibleContentWidth: UIScreen.main.bounds.width / 5)
        self.transitionOptions.animationOptions = [.curveEaseOut]
        
        self.menuViewController = SideMenuViewController(nibName: "SideMenuViewController", bundle: nil)
        self.contentViewControllers = loadContentViewControllers()
        self.selectContentViewController(contentViewControllers[1])
    }

    private func loadContentViewControllers() -> [UIViewController] {
        let vc0 = ContentNavigationController()
        vc0.viewControllers = [PostsSearchViewController()]
        
        let vc1 = ContentNavigationController()
        vc1.viewControllers = [QuestionsViewController()]
    
        let vc2 = ContentNavigationController()
        vc2.viewControllers = [TagsViewController()]
        
        let vc3 = ContentNavigationController()
        vc3.viewControllers = [UsersViewController()]
        
        let vc4 = ContentNavigationController()
        vc4.viewControllers = [BrowsingHistoryViewController()]
        
        let vc5 = ContentNavigationController()
        vc5.viewControllers = [FavoriteQuestionsViewController()]
        
        let vc6 = ContentNavigationController()
        vc6.viewControllers = [TabBarController(with: [InboxItemsViewController(), NotificationsViewController()])]
        
        let vc7 = ContentNavigationController()
        vc7.viewControllers = [UserQuestionsViewController()]

        return [vc0, vc1, vc2, vc3, vc4, vc5, vc6, vc7]
    }
}
