//
//  SideMenuViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/21/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import InteractiveSideMenu

class SideMenuViewController: MenuViewController {
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var badgesStackView: UIStackView!
    
    @IBOutlet weak var goldBadgesLabel: UILabel!
    @IBOutlet weak var silverBadgesLabel: UILabel!
    @IBOutlet weak var bronzeBadgesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mainAppColor.withAlphaComponent(0.9)
        
        menuTableView.backgroundColor = .clear
        menuTableView.separatorStyle = .none
        menuTableView.register(UINib(nibName: "MenuItemCell", bundle: nil), forCellReuseIdentifier: String(describing: MenuItemCell.self))
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.allowsMultipleSelection = false
        menuTableView.isScrollEnabled = false
        menuTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MenuItemCell.self), for: indexPath) as! MenuItemCell
        
        cell.iconImageView.image = UIImage(named: "menu_icon")!.withRenderingMode(.alwaysTemplate)
        cell.menuItemLabel.text = "Questions"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return tableView.cellForRow(at: indexPath)!.isSelected ? nil : indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menuController = self.menuContainerViewController {
            menuController.selectContentViewController(menuController.contentViewControllers[indexPath.row])
            menuController.hideSideMenu()
        }
    }
}
