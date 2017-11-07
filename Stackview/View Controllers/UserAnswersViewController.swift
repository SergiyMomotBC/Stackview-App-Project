//
//  UserAnswersViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/15/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class UserAnswersViewController: DataPresenterViewController<Answer, UserAnswerTableViewCell>, Tabbable {
    private var sortingOption = PostsSortOption.creation
    private let user: User
    
    var icon: UIImage {
        return UIImage(named: "answers_icon")!.withRenderingMode(.alwaysTemplate)
    }
    
    var iconTitle: String {
        return "Answers"
    }
    
    init(for user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        
        self.dataSource = self
        self.title = "\(user.name!)'s answers"
        self.dropDownItems = ["Newest", "Most voted", "Recently active"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func handleDropDownSelection(for index: Int) {
        switch index {
        case 0:
            sortingOption = .creation
        case 1:
            sortingOption = .votes(min: nil, max: nil)
        case 2:
            sortingOption = .activity(min: nil, max: nil)
        default:
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = QuestionDetailViewController(for: String(data[indexPath.row].questionID!), answerIDToPresentFirst: data[indexPath.row].id, saveVisit: true)
        navigationController?.show(vc, sender: nil)
    }
}

extension UserAnswersViewController: RemoteDataSource {
    var endpoint: String {
        return "users/\(user.id!)/answers"
    }
    
    var parameters: [ParametersConvertible] {
        return [SortingParameters(option: sortingOption, order: .descending)]
    }
}
