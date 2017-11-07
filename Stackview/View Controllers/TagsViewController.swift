//
//  TagsViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/31/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class TagsViewController: DataPresenterViewController<Tag, TagTableViewCell> {
    private var sortingOption: TagsSortOption = .popular(min: nil, max: nil)
    private let user: User?
    private var creationDateOption: CreationDateFilterParameters?
    
    init(for user: User? = nil) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        
        self.title = user == nil ? "Tags" : "\(user!.name!)'s tags"
        self.dropDownItems = ["Popular", "Recently used", "Top new in a week", "Top new in a month"]
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search_icon")!.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(showSearch))
        }
    }
    
    override func handleDropDownSelection(for index: Int) {
        switch index {
        case 0:
            sortingOption = .popular(min: nil, max: nil)
            creationDateOption = nil
        case 1:
            sortingOption = .activity(min: nil, max: nil)
            creationDateOption = nil
        case 2:
            sortingOption = .popular(min: nil, max: nil)
            creationDateOption = CreationDateFilterParameters(fromDate: Calendar.current.date(byAdding: .day, value: -7, to: Date(), wrappingComponents: false), toDate: nil)
        case 3:
            sortingOption = .popular(min: nil, max: nil)
            creationDateOption = CreationDateFilterParameters(fromDate: Calendar.current.date(byAdding: .day, value: -30, to: Date(), wrappingComponents: false), toDate: nil)
        default:
            fatalError()
        }
    }
    
    @objc func showSearch() {
        navigationController?.show(TagsSearchViewController(), sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let user = self.user {
            let vc = UserTaggedPostsViewController(for: user, tagName: data[indexPath.row].name!)
            navigationController?.show(vc, sender: nil)
        } else {
            let questionsVC = QuestionsViewController(for: data[indexPath.row])
            navigationController?.show(questionsVC, sender: nil)
        }
    }
}

extension TagsViewController: RemoteDataSource {
    var endpoint: String {
        return user == nil ? "tags" : "users/\(user!.id!)/tags"
    }
    
    var parameters: [ParametersConvertible] {
        if let dateOptions = creationDateOption {
            return [SortingParameters(option: sortingOption, order: .descending), dateOptions]
        } else {
            return [SortingParameters(option: sortingOption, order: .descending)]
        }
    }
}
