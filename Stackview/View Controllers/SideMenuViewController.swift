//
//  SideMenuViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/21/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import InteractiveSideMenu
import NotificationCenter
import CFAlertViewController

fileprivate struct MenuItem {
    let icon: UIImage
    let title: String
    let vcIndex: Int
}

fileprivate let guestOptions = [MenuItem(icon: UIImage(named: "search_menu")!, title: "Search", vcIndex: 0),
                                nil,
                                MenuItem(icon: UIImage(named: "questions_menu")!, title: "Questions", vcIndex: 1),
                                MenuItem(icon: UIImage(named: "tags_menu")!, title: "Tags", vcIndex: 2),
                                MenuItem(icon: UIImage(named: "users_menu")!, title: "Users", vcIndex: 3),
                                nil,
                                MenuItem(icon: UIImage(named: "browsing_history_menu")!, title: "Browsing history", vcIndex: 4)]

fileprivate let userOptions = [MenuItem(icon: UIImage(named: "search_menu")!, title: "Search", vcIndex: 0),
                               nil,
                               MenuItem(icon: UIImage(named: "questions_menu")!, title: "Questions", vcIndex: 1),
                               MenuItem(icon: UIImage(named: "tags_menu")!, title: "Tags", vcIndex: 2),
                               MenuItem(icon: UIImage(named: "users_menu")!, title: "Users", vcIndex: 3),
                               nil,
                               MenuItem(icon: UIImage(named: "favorite_icon")!, title: "Favorites", vcIndex: 5),
                               MenuItem(icon: UIImage(named: "inbox_menu")!, title: "Inbox", vcIndex: 6),
                               MenuItem(icon: UIImage(named: "asked_questions_menu")!, title: "Asked questions", vcIndex: 7),
                               nil,
                               MenuItem(icon: UIImage(named: "browsing_history_menu")!, title: "Browsing history", vcIndex: 4)]

class SideMenuViewController: MenuViewController {
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var reputationLabel: UILabel!
    @IBOutlet weak var badgesOrLoginContainer: UIView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileInfoContainer: UIView!
    @IBOutlet weak var headerInfoHeightConstraint: NSLayoutConstraint!
    
    lazy var logInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.flatRed, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        button.addTarget(self, action: #selector(requestAuthentication), for: .touchUpInside)
        return button
    }()
    
    lazy var badgesView: BadgesView = {
        let view = BadgesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .white
        return view
    }()
    
    fileprivate var menuItems: [MenuItem?] = []
    fileprivate var wasAuthenticated = false
    fileprivate var timer: Timer?
    fileprivate var api = StackExchangeRequest()
    var isPresented = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mainAppColor.withAlphaComponent(0.8)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userAuthStatusChanged),
                                               name: NSNotification.Name(rawValue: AuthenticatedUser.userAuthenticatedNotificationName),
                                               object: nil)
        
        menuTableView.backgroundColor = .clear
        menuTableView.separatorStyle = .none
        menuTableView.register(UINib(nibName: "MenuItemCell", bundle: nil), forCellReuseIdentifier: String(describing: MenuItemCell.self))
        menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.allowsMultipleSelection = false
        menuTableView.isScrollEnabled = false
        
        logOutButton.setTitleColor(.flatRed, for: .normal)
        logOutButton.setTitleColor(.lightGray, for: .highlighted)
        logOutButton.addTarget(self, action: #selector(requestDeauthentication), for: .touchUpInside)
        
        profileImageView.isUserInteractionEnabled = false
        
        var constant: CGFloat
        if UIScreen.main.bounds.width <= 320 {
            constant = 16
            headerInfoHeightConstraint.constant = 48.0
        } else if UIScreen.main.bounds.width <= 375 {
            constant = 20
        } else {
            constant = 24
        }
        
        if #available(iOS 11.0, *) {
            topConstraint.constant = constant
        } else {
            topConstraint.constant = constant + UIApplication.shared.statusBarFrame.height
        }
        
        bottomConstraint.constant = -constant - UIApplication.shared.statusBarFrame.height + 8.0
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showUserProfile))
        tapRecognizer.numberOfTapsRequired = 1
        profileInfoContainer.addGestureRecognizer(tapRecognizer)
        profileInfoContainer.isUserInteractionEnabled = true
        
        userAuthStatusChanged()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isPresented = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isPresented = false
    }
    
    @objc private func showUserProfile() {
        guard let userid = AuthenticatedUser.current.userInfo?.id else { return }
        
        let navigationController = ContentNavigationController()
        navigationController.viewControllers = [UserProfileViewController(for: String(userid))]
        navigationController.loadViewIfNeeded()
        navigationController.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain,
                                                                                         target: self, action: #selector(hideUserProfile))
        
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc private func hideUserProfile() {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func requestAuthentication() {
        AuthenticatedUser.current.authenticate()
    }
    
    @objc private func requestDeauthentication() {
        let alert = CFAlertViewController(title: "Log out", titleColor: .mainAppColor, message: "Are you sure you want to log out from your user account?", messageColor: .flatBlack,
                                          textAlignment: .justified, preferredStyle: .alert, headerView: nil, footerView: nil, didDismissAlertHandler: nil)
        
        let yesButton = CFAlertAction(title: "Confirm", style: .Default, alignment: .justified, backgroundColor: .flatPurple, textColor: .white) { _ in
            AuthenticatedUser.current.deauthenticate()
        }
        
        let noButton = CFAlertAction(title: "Cancel", style: .Default, alignment: .justified, backgroundColor: .flatRed, textColor: .white, handler: nil)
        
        alert.addAction(noButton)
        alert.addAction(yesButton)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func userAuthStatusChanged() {
        if let currentUser = AuthenticatedUser.current.userInfo {
            reputationLabel.isHidden = false
            reputationLabel.text = currentUser.reputation!.toString()
            badgesOrLoginContainer.subviews.first?.removeFromSuperview()
            badgesOrLoginContainer.addSubview(badgesView)
            badgesView.leadingAnchor.constraint(equalTo: badgesOrLoginContainer.leadingAnchor).isActive = true
            badgesView.trailingAnchor.constraint(equalTo: badgesOrLoginContainer.trailingAnchor).isActive = true
            badgesView.topAnchor.constraint(equalTo: badgesOrLoginContainer.topAnchor).isActive = true
            badgesView.bottomAnchor.constraint(equalTo: badgesOrLoginContainer.bottomAnchor).isActive = true
            profileImageView.setUser(currentUser)
            usernameLabel.text = currentUser.name
            badgesView.setup(for: currentUser.badgeCounts!)
            menuItems = userOptions
            logOutButton.isHidden = false
            wasAuthenticated = true
            
            timer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true, block: { [weak self] _ in
                self?.api.makeRequest(to: "me", completion: { (users: [User]?, _, _) in
                    if let user = users?.first {
                        AuthenticatedUser.current.userInfo = user
                        self?.profileImageView.setUser(user)
                        self?.badgesView.setup(for: user.badgeCounts!)
                        self?.reputationLabel.text = user.reputation?.toString()
                    }
                })
            })
        } else {
            reputationLabel.isHidden = true
            badgesOrLoginContainer.subviews.first?.removeFromSuperview()
            badgesOrLoginContainer.addSubview(logInButton)
            logInButton.centerYAnchor.constraint(equalTo: badgesOrLoginContainer.centerYAnchor).isActive = true
            logInButton.leadingAnchor.constraint(equalTo: badgesOrLoginContainer.leadingAnchor).isActive = true
            profileImageView.image = UIImage(named: "guest")
            usernameLabel.text = "Guest user"
            menuItems = guestOptions
            logOutButton.isHidden = true
            
            if let menuController = self.menuContainerViewController, wasAuthenticated {
                menuController.selectContentViewController(menuController.contentViewControllers[menuItems[2]!.vcIndex])
                menuController.hideSideMenu()
            }
            
            wasAuthenticated = false
            timer?.invalidate()
        }
        
        menuTableView.reloadData()
        menuTableView.selectRow(at: IndexPath(row: 2, section: 0), animated: false, scrollPosition: .none)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let menuItem = menuItems[indexPath.row] {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MenuItemCell.self), for: indexPath) as! MenuItemCell
            cell.iconImageView.image = menuItem.icon.withRenderingMode(.alwaysTemplate)
            cell.menuItemLabel.text = menuItem.title
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
            
            if cell.contentView.subviews.isEmpty {
                cell.contentView.backgroundColor = .clear
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
                cell.contentView.addSubview(view)
                view.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
                view.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
                view.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true
                view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if menuItems[indexPath.row] == nil {
            return 16
        } else if UIScreen.main.bounds.width <= 320 {
            return 35
        } else if UIScreen.main.bounds.width <= 375 {
            return 40
        } else {
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return (tableView.cellForRow(at: indexPath)!.isSelected || menuItems[indexPath.row] == nil) ? nil : indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menuController = self.menuContainerViewController {
            menuController.selectContentViewController(menuController.contentViewControllers[menuItems[indexPath.row]!.vcIndex])
            menuController.hideSideMenu()
        }
    }
}
