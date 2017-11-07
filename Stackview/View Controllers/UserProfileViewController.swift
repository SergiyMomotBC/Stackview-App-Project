//
//  UserProfileViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/11/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import StatefulViewController

class UserProfileViewController: DataViewController {
    @IBOutlet weak var tabsContainer: UIView!
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var badgesView: BadgesView!
    @IBOutlet weak var reputationLabel: UILabel!
    @IBOutlet weak var pagesContainerView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var user: User?
    let userID: String
    let api = StackExchangeRequest()
    let tabsSelector = TabSelectorView(tabs: ["Profile", "Top posts", "Top tags", "Recent badges"])
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var previousPage = 0
    var pages: [UIViewController & Scrollable] = []
    var previousContentOffset: CGFloat = 0.0
    var currentP: CGFloat = 1.0
    
    let maxHeight: CGFloat = 100.0
    let minHeight: CGFloat = 0.0
    
    init(for userID: String) {
        self.userID = userID
        super.init(nibName: "UserProfileViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mainAppColor
        
        badgesView.textColor = .white
        profileImageView.isUserInteractionEnabled = false
        
        tabsSelector.translatesAutoresizingMaskIntoConstraints = false
        tabsContainer.addSubview(tabsSelector)
        tabsSelector.topAnchor.constraint(equalTo: tabsContainer.topAnchor).isActive = true
        tabsSelector.leadingAnchor.constraint(equalTo: tabsContainer.leadingAnchor).isActive = true
        tabsSelector.trailingAnchor.constraint(equalTo: tabsContainer.trailingAnchor).isActive = true
        tabsSelector.bottomAnchor.constraint(equalTo: tabsContainer.bottomAnchor).isActive = true
        
        tabsSelector.tabChangedHandler = { [weak self] index in
            if let this = self {
                this.pageViewController.setViewControllers([this.pages[index]], direction: this.previousPage < index ? .forward : .reverse, animated: true, completion: nil)
                this.previousPage = index
                this.previousContentOffset = this.pages[index].scrollView.contentOffset.y
            }
        }
        
        addChildViewController(pageViewController)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pagesContainerView.addSubview(pageViewController.view)
        pageViewController.view.topAnchor.constraint(equalTo: pagesContainerView.topAnchor).isActive = true
        pageViewController.view.leadingAnchor.constraint(equalTo: pagesContainerView.leadingAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: pagesContainerView.trailingAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: pagesContainerView.bottomAnchor).isActive = true
        pageViewController.didMove(toParentViewController: self)
        
        loadUserInfo()
        
        navigationItem.title = "Profile"
    }

    func loadUserInfo() {
        loading = true
        startLoading()
        
        api.makeRequest(to: "users/\(userID)", with: []) { (results: [User]?, error: RequestError?, _) in
            if let requestError = error {
                switch requestError {
                case .noInternetConnection:
                    self.endLoading(animated: true, error: ErrorType.noConnection, completion: nil)
                default:
                    self.endLoading(animated: true, error: ErrorType.other, completion: nil)
                }
            } else {
                self.user = results?.first
                self.displayInfo()
                self.endLoading(animated: true, error: nil, completion: nil)
            }

            self.loading = false
        }
    }
    
    private func displayInfo() {
        guard let user = self.user else { return }
        
        profileImageView.setUser(user)
        
        nameLabel.text = user.name
        reputationLabel.text = (user.reputation ?? 0).toString()
        badgesView.setup(for: user.badgeCounts!)
        
        let upivc = UserProfileInfoViewController(for: user)
        upivc.view.tag = 0
        upivc.scrollDelegate = self
        pages.append(upivc)
        
        let tpvc = TopPostsViewController(for: user)
        tpvc.scrollDelegate = self
        pages.append(tpvc)
        
        let vc = TopTagsViewController(for: user)
        pages.append(vc)
        vc.scrollDelegate = self
        
        let rbvc = RecentBadgesViewController(for: user)
        rbvc.scrollDelegate = self
        pages.append(rbvc)
        
        pageViewController.setViewControllers([pages.first!], direction: .forward, animated: false, completion: nil)
    }
    
    override func hasContent() -> Bool {
        return user != nil
    }
}

extension UserProfileViewController: UserProfileTabViewControllerDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let dy = previousContentOffset - scrollView.contentOffset.y
        
        if dy < 0 || scrollView.contentOffset.y < (maxHeight - minHeight) {
            let dp = dy / (maxHeight - minHeight)
            currentP = min(1.0, max(0.0, currentP + dp))
            applyPercentage(currentP)
        }
        
        navigationItem.title = scrollView.contentOffset.y > maxHeight / 2 ? "\(user?.name ?? "Unknown")'s profile" : "Profile"
        
        previousContentOffset = scrollView.contentOffset.y
    }
    
    private func applyPercentage(_ p: CGFloat) {
        topConstraint.constant = (minHeight + (maxHeight - minHeight) * p) - maxHeight
        headerView.alpha = p
    }
}









































