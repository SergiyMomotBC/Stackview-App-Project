//
//  BadgesViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/1/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class BadgesViewController: DataPresenterViewController<Badge, BadgeTableViewCell> {
    fileprivate var sortingOption: BadgesSortOption = .name(min: nil, max: nil)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.title = "Badges"
        self.dropDownItems = ["All", "Gold", "Silver", "Bronze"]
        
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearch))
    }
    
    override func handleDropDownSelection(for index: Int) {
        switch index {
        case 0:
            sortingOption = .name(min: nil, max: nil)
        case 1:
            sortingOption = .rank(min: nil, max: .gold)
        case 2:
            sortingOption = .rank(min: .silver, max: .silver)
        case 3:
            sortingOption = .rank(min: .bronze, max: nil)
        default:
            fatalError()
        }
    }
    
    @objc func showSearch() {
        //navigationController?.show(QuestionsSearchViewController(), sender: nil)
    }
}

extension BadgesViewController: RemoteDataSource {
    var endpoint: String {
        return "badges/name"
    }
    
    var parameters: [ParametersConvertible] {
        return [SortingParameters(option: sortingOption, order: .ascending)]
    }
}
