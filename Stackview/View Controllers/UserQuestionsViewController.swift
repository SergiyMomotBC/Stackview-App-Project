//
//  UserQuestionsViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/15/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class UserQuestionsViewController: DataPresenterViewController<Question, UserQuestionTableViewCell> {
    private var sortingOption = PostsSortOption.creation
    private var user: User!
    private var endpointPath: String!
    
    init(for user: User? = nil) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        if user == nil {
            user = AuthenticatedUser.current.userInfo
            self.title = "Asked questions"
        } else {
            self.title = "\(user!.name!)'s questions"
        }
        
        self.endpointPath = "users/\(user!.id!)/questions"
        self.dropDownItems = ["Newest", "Most voted", "Recently active", "Featured", "Unanswered"]
        
        super.viewDidLoad()
    }
    
    override func handleDropDownSelection(for index: Int) {
        switch index {
        case 0:
            sortingOption = .creation
            endpointPath = "users/\(user!.id!)/questions"
        case 1:
            sortingOption = .votes(min: nil, max: nil)
            endpointPath = "users/\(user.id!)/questions"
        case 2:
            sortingOption = .activity(min: nil, max: nil)
            endpointPath = "users/\(user.id!)/questions"
        case 3:
            sortingOption = .creation
            endpointPath = "users/\(user.id!)/questions/featured"
        case 4:
            sortingOption = .creation
            endpointPath = "users/\(user.id!)/questions/unanswered"
        default:
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let questionsVC = QuestionDetailViewController(for: String(data[indexPath.row].id!))
        navigationController?.show(questionsVC, sender: nil)
    }
}

extension UserQuestionsViewController: RemoteDataSource {
    var endpoint: String {
        return endpointPath
    }
    
    var parameters: [ParametersConvertible] {
        return [SortingParameters(option: sortingOption, order: .descending)]
    }
}

extension UserQuestionsViewController: Tabbable {
    var icon: UIImage {
        return UIImage(named: "question_icon")!.withRenderingMode(.alwaysTemplate)
    }
    
    var iconTitle: String {
        return "Questions"
    }
}
