//
//  TabbarController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/8/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class TabBarController: DataViewController {
    let tabBar = ColorTabs()
    let containerView = UIView()
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var viewControllers: [UIViewController & Tabbable] = []
    var previouslySelectedSegmentIndex = -1
    
    init(with viewControllers: [UIViewController & Tabbable]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
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
        if #available(iOS 11.0, *) {
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8.0).isActive = true
            tabBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0).isActive = true
            tabBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0).isActive = true
        } else {
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8.0).isActive = true
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        }
        
        tabBar.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        tabBar.reloadData()
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear
        view.addSubview(containerView)
        if #available(iOS 11.0, *) {
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        } else {
            containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        }
        containerView.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -8.0).isActive = true
        
        addChildViewController(pageViewController)
        containerView.addSubview(pageViewController.view)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        pageViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        pageViewController.didMove(toParentViewController: self)
        
        if !viewControllers.isEmpty {
            tabBar.selectedSegmentIndex = 0
            tabSelected()
        }
    }
    
    func setViewControllers(_ viewControllers: [UIViewController & Tabbable], initialIndex: Int = 0) {
        self.viewControllers = viewControllers
        tabBar.selectedSegmentIndex = initialIndex
        tabBar.reloadData()
        tabSelected()
    }
    
    @objc func tabSelected() {
        pageViewController.setViewControllers([viewControllers[tabBar.selectedSegmentIndex]],
                                              direction: tabBar.selectedSegmentIndex > previouslySelectedSegmentIndex ? .forward : .reverse,
                                              animated: true,
                                              completion: nil)
        
        if let titleView = viewControllers[tabBar.selectedSegmentIndex].navigationItem.titleView {
            navigationItem.titleView = titleView
        } else {
            navigationItem.titleView = nil
            navigationItem.title = viewControllers[tabBar.selectedSegmentIndex].navigationItem.title
        }
        
        if let rightButtons = viewControllers[tabBar.selectedSegmentIndex].navigationItem.rightBarButtonItems {
            navigationItem.rightBarButtonItems = rightButtons
        }
        
        if let leftButtons = viewControllers[tabBar.selectedSegmentIndex].navigationItem.leftBarButtonItems {
            navigationItem.leftBarButtonItems = leftButtons
        }
        
        previouslySelectedSegmentIndex = tabBar.selectedSegmentIndex
    }
}

extension TabBarController: ColorTabsDataSource {
    func numberOfItems(inTabSwitcher tabSwitcher: ColorTabs) -> Int {
        return viewControllers.count
    }
    
    func tabSwitcher(_ tabSwitcher: ColorTabs, titleAt index: Int) -> String {
        return viewControllers[index].iconTitle
    }
    
    func tabSwitcher(_ tabSwitcher: ColorTabs, iconAt index: Int) -> UIImage {
        return viewControllers[index].icon
    }
    
    func tabSwitcher(_ tabSwitcher: ColorTabs, hightlightedIconAt index: Int) -> UIImage {
        return viewControllers[index].icon
    }
    
    func tabSwitcher(_ tabSwitcher: ColorTabs, tintColorAt index: Int) -> UIColor {
        return UIColor.flatRed
    }
}
