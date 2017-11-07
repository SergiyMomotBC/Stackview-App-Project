//
//  FavoriteQuestionsViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 10/17/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class FavoriteQuestionsViewController: DataPresenterViewController<Question, QuestionTableViewCell> {
    private let userID: Int?
    private var sortingOption: AddedQuestionsSortOption = .added(min: nil, max: nil)
    
    init(forUserID userID: Int? = nil) {
        self.userID = userID
        super.init(nibName: nil, bundle: nil)
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.title = "Favorite questions"
        self.dropDownItems = ["Recently added", "Newest", "Most voted", "Recently active"]
        super.viewDidLoad()
    }
    
    override func handleDropDownSelection(for index: Int) {
        switch index {
        case 0:
            sortingOption = .added(min: nil, max: nil)
        case 1:
            sortingOption = .creation
        case 2:
            sortingOption = .votes(min: nil, max: nil)
        case 3:
            sortingOption = .activity(min: nil, max: nil)
        default:
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = QuestionDetailViewController(for: String(data[indexPath.row].id!))
        navigationController?.show(vc, sender: nil)
    }
}

extension FavoriteQuestionsViewController: RemoteDataSource {
    var endpoint: String {
        if let id = self.userID {
            return "user/\(id)/favorites"
        } else {
            return "me/favorites"
        }
    }
    
    var parameters: [ParametersConvertible] {
        return [SortingParameters(option: sortingOption, order: .descending)]
    }
}
