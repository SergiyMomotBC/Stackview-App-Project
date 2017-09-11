//
//  UserSearchViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/11/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class UsersSearchViewController: SearchViewController<User, UserTableViewCell> {
    init() {
        super.init(for: .user, searchPrompt: "Search users...")
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
    }
}

extension UsersSearchViewController: RemoteDataSource {
    var endpoint: String {
        return "users"
    }
    
    var parameters: [ParametersConvertible] {
        return [SortingParameters(option: UsersSortOption.reputation(min: nil, max: nil), order: .descending),
                InnameSearchParameter(query: searchbar.text!)]
    }
}
