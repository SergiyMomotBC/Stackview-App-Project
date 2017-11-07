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
    var creationDateOption: CreationDateFilterParameters?
    var endpointPath = "users"
    var order: SortingOrder = .descending
    
    init() {
        super.init(nibName: nil, bundle: nil)
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.title = "Users"
        self.dropDownItems = ["Top", "Newest", "Top new in a week", "Top new in a month", "Moderators"]
        
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 0.0
        tableView.rowHeight = 80.0
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search_icon")!.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(showSearch))
    }
    
    override func handleDropDownSelection(for index: Int) {
        endpointPath = "users"
        order = .descending
        
        switch index {
        case 0:
            sortingOption = .reputation(min: nil, max: nil)
            creationDateOption = nil
        case 1:
            sortingOption = .creation
            creationDateOption = nil
        case 2:
            sortingOption = .reputation(min: nil, max: nil)
            creationDateOption = CreationDateFilterParameters(fromDate: Calendar.current.date(byAdding: .day, value: -7, to: Date(), wrappingComponents: false), toDate: nil)
        case 3:
            sortingOption = .reputation(min: nil, max: nil)
            creationDateOption = CreationDateFilterParameters(fromDate: Calendar.current.date(byAdding: .day, value: -30, to: Date(), wrappingComponents: false), toDate: nil)
        case 4:
            sortingOption = .name(min: nil, max: nil)
            creationDateOption = nil
            endpointPath = "users/moderators"
            order = .ascending
        default:
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let questionsVC = UserProfileViewController(for: String(data[indexPath.row].id ?? 0))
        navigationController?.show(questionsVC, sender: nil)
    }
    
    @objc func showSearch() {
        navigationController?.show(UsersSearchViewController(), sender: nil)
    }
}

extension UsersViewController: RemoteDataSource {
    var endpoint: String {
        return endpointPath
    }
    
    var parameters: [ParametersConvertible] {
        if let dateOptions = creationDateOption {
            return [SortingParameters(option: self.sortingOption, order: order), dateOptions]
        } else {
            return [SortingParameters(option: self.sortingOption, order: order)]
        }
    }
}
