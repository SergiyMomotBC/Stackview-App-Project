//
//  TopPostsViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/13/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class TopPostsViewController: UserProfileTabViewController<Post, PostTableViewCell>, Scrollable {
    let user: User
    
    var scrollView: UIScrollView {
        return tableView
    }
    
    init(for user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        dataSource = self
        buttonTitleText = "View all posts"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func showAllData() {
        let avc = UserAnswersViewController(for: user)
        let qvc = UserQuestionsViewController(for: user)
        let vc = TabBarController(with: [qvc, avc])
        navigationController?.show(vc, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let post = data[indexPath.row]
        if post.type! == .question {
            let vc = QuestionDetailViewController(for: String(post.id!))
            navigationController?.show(vc, sender: nil)
        } else {
            let vc = QuestionDetailViewController(forAnswerID: String(post.id!))
            navigationController?.show(vc, sender: nil)
        }
    }
}

extension TopPostsViewController: RemoteDataSource {
    var endpoint: String {
        return "users/\(user.id!)/posts"
    }
    
    var parameters: [ParametersConvertible] {
        return [SortingParameters(option: PostsSortOption.votes(min: nil, max: nil), order: .descending)]
    }
}
