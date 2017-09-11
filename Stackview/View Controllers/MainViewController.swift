//
//  MainViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/21/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class TestVC1: UIViewController, Iconable {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorites"
        view.backgroundColor = .green
    }
    
    var icon: UIImage {
        return UIImage(named: "icon1")!.withRenderingMode(.alwaysTemplate)
    }
}

class TestVC2: UIViewController, Iconable {
    override func viewDidLoad() {
        self.title = "Twitter"
        super.viewDidLoad()
        view.backgroundColor = .brown
    }
    
    var icon: UIImage {
        return UIImage(named: "icon2")!.withRenderingMode(.alwaysTemplate)
    }
}

class MainViewController: MenuContainerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.transitionOptions = TransitionOptions(duration: 0.4, visibleContentWidth: UIScreen.main.bounds.width / 5)
        self.transitionOptions.animationOptions = [.curveEaseInOut]
        self.menuViewController = SideMenuViewController(nibName: "SideMenuViewController", bundle: nil)
        self.contentViewControllers = loadContentViewControllers()
        self.selectContentViewController(self.contentViewControllers.first!)
    }

    private func loadContentViewControllers() -> [UIViewController] {
        var controllers: [UIViewController] = []
        
        let n1 = ContentNavigationController()
        n1.viewControllers = [QuestionsViewController()]
        controllers.append(n1)
        
        let n2 = ContentNavigationController()
        n2.viewControllers = [TagsViewController()]
        controllers.append(n2)
        
        let n3 = ContentNavigationController()
        n3.viewControllers = [BadgesViewController()]
        controllers.append(n3)
        
        let n4 = ContentNavigationController()
        n4.viewControllers = [UsersViewController()]
        controllers.append(n4)
        
        return controllers
    }
}
