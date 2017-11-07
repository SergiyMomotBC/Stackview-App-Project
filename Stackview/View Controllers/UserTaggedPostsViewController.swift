//
//  UserTaggedPostsViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/14/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class UserTaggedPostsViewController: DataPresenterViewController<SearchExcerpt, SearchExcerptTableViewCell> {
    var searchOptions = SearchParameters()
    var sortingOption = RelevantQuestionsSortOption.creation
    let user: User
    let tagName: String
    
    init(for user: User, tagName: String) {
        self.user = user
        self.tagName = tagName
    
        super.init(nibName: nil, bundle: nil)
        
        self.searchOptions.userID = user.id
        self.searchOptions.taggedList = [tagName]
        self.title = "Posts tagged \(tagName)"
        self.dropDownItems = ["Newest", "Most voted", "Recently active"]
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search_icon")!.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(showSearch))
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
        
        let post = data[indexPath.row]
        if post.itemType! == .question {
            let vc = QuestionDetailViewController(for: String(post.questionID!))
            navigationController?.show(vc, sender: nil)
        } else {
            let vc = QuestionDetailViewController(for: String(post.questionID!), answerIDToPresentFirst: post.answerID)
            navigationController?.show(vc, sender: nil)
        }
    }
    
    @objc func showSearch() {
        let svc = PostsSearchViewController(dissmisable: true)
        svc.searchParameters.userID = user.id
        svc.searchParameters.taggedList = [tagName]
        navigationController?.show(svc, sender: nil)
    }
}

extension UserTaggedPostsViewController: RemoteDataSource {
    var endpoint: String {
        return "search/excerpts"
    }
    
    var parameters: [ParametersConvertible] {
        return [searchOptions, SortingParameters(option: sortingOption, order: .descending)]
    }
}
