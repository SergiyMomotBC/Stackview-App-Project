//
//  UserViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/11/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class UsersViewController: DataPresenterViewController<User, UserTableViewCell> {
    var sortingOption: UsersSortOption = .reputation(min: nil, max: nil)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.title = "Users"
        self.dropDownItems = ["Reputabel", "Newest", "Alphabetical order"]
        
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearch))
    }
    
    override func handleDropDownSelection(for index: Int) {
        switch index {
        case 0:
            sortingOption = .reputation(min: nil, max: nil)
        case 1:
            sortingOption = .creation
        case 2:
            sortingOption = .name(min: nil, max: nil)
        default:
            fatalError()
        }
    }
    
    @objc func showSearch() {
        navigationController?.show(UsersSearchViewController(), sender: nil)
    }
}

extension UsersViewController: RemoteDataSource {
    var endpoint: String {
        return "users"
    }
    
    var parameters: [ParametersConvertible] {
        return [SortingParameters(option: self.sortingOption, order: .descending)]
    }
}
