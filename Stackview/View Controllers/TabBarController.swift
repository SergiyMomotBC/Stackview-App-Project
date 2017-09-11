//
//  TabbarController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/8/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

protocol Iconable where Self: UIViewController {
    var icon: UIImage { get }
}

class TabBarController: UIViewController {
    let tabBar = ColorTabs()
    let containerView = UIView()
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    let viewControllers: [UIViewController & Iconable]
    var previouslySelectedSegmentIndex = -1
    
    init(with viewControllers: [UIViewController & Iconable]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mainAppColor
        
        tabBar.dataSource = self
        tabBar.addTarget(self, action: #selector(tabSelected), for: .valueChanged)
        view.addSubview(tabBar)
        tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8.0).isActive = true
        tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tabBar.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        tabBar.reloadData()
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear
        view.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -8.0).isActive = true
        
        addChildViewController(pageViewController)
        containerView.addSubview(pageViewController.view)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        pageViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        pageViewController.didMove(toParentViewController: self)
        
        pageViewController.setViewControllers([viewControllers.first!], direction: .forward, animated: false, completion: nil)
    }
    
    @objc private func tabSelected() {
        pageViewController.setViewControllers([viewControllers[tabBar.selectedSegmentIndex]],
                                              direction: tabBar.selectedSegmentIndex > previouslySelectedSegmentIndex ? .forward : .reverse,
                                              animated: true,
                                              completion: nil)
        
        previouslySelectedSegmentIndex = tabBar.selectedSegmentIndex
    }
}

extension TabBarController: ColorTabsDataSource {
    func numberOfItems(inTabSwitcher tabSwitcher: ColorTabs) -> Int {
        return viewControllers.count
    }
    
    func tabSwitcher(_ tabSwitcher: ColorTabs, titleAt index: Int) -> String {
        return viewControllers[index].title ?? "Hello"
    }
    
    func tabSwitcher(_ tabSwitcher: ColorTabs, iconAt index: Int) -> UIImage {
        return viewControllers[index].icon
    }
    
    func tabSwitcher(_ tabSwitcher: ColorTabs, hightlightedIconAt index: Int) -> UIImage {
        return viewControllers[index].icon
    }
    
    func tabSwitcher(_ tabSwitcher: ColorTabs, tintColorAt index: Int) -> UIColor {
        return UIColor.secondaryAppColor
    }
}
