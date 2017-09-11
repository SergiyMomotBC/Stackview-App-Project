//
//  TagsViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/31/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class TagsViewController: DataPresenterViewController<Tag, TagTableViewCell> {
    fileprivate var sortingOption: TagsSortOption = .popular(min: nil, max: nil)
    var isAlphabetical = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.title = "Tags"
        self.dropDownItems = ["Popular", "Recently used", "Alphabetical order"]
        
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearch))
    }
    
    override func handleDropDownSelection(for index: Int) {
        switch index {
        case 0:
            sortingOption = .popular(min: nil, max: nil)
            isAlphabetical = false
        case 1:
            sortingOption = .activity(min: nil, max: nil)
            isAlphabetical = false
        case 2:
            sortingOption = .name(min: nil, max: nil)
            isAlphabetical = true
        default:
            fatalError()
        }
    }
    
    @objc func showSearch() {
        navigationController?.show(TagsSearchViewController(), sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let questionsVC = QuestionsViewController(for: data[indexPath.row])
        navigationController?.show(questionsVC, sender: nil)
    }
}

extension TagsViewController: RemoteDataSource {
    var endpoint: String {
        return "tags"
    }
    
    var parameters: [ParametersConvertible] {
        return [SortingParameters(option: sortingOption, order: isAlphabetical ? .ascending : .descending)]
    }
    
    
}
