//
//  UserProfileInfoViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/13/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class UserProfileInfoViewController: DataViewController, Scrollable, LinkHandler {
    var scrollView: UIScrollView {
        return tableView
    }

    weak var scrollDelegate: UserProfileTabViewControllerDelegate?
    let user: User
    let tableView = DataTableView()
    
    init(for user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: String(describing: UserProfileTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UserProfileTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 1000.0
        tableView.bounces = false
        
        view.addSubview(tableView)
        if #available(iOS 11.0, *) {
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    }
}

extension UserProfileInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }

        scrollDelegate?.scrollViewDidScroll(scrollView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserProfileTableViewCell.self), for: indexPath) as! UserProfileTableViewCell
        cell.aboutWebView.linkHandler = self
        cell.setup(for: self.user)
        return cell
    }
}
