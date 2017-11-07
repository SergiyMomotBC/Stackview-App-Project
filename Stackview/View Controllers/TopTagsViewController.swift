//
//  TopTagsViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/12/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class TopTagsViewController: UserProfileTabViewController<TopTag, TopTagTableViewCell>, Scrollable {
    let user: User
    
    var scrollView: UIScrollView {
        return tableView
    }
    
    init(for user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        dataSource = self
        buttonTitleText = "View all tags"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 0.0
        tableView.rowHeight = 90.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! TopTagTableViewCell
        let totalPosts = Double((data[indexPath.row].answersCount ?? 0) + (data[indexPath.row].questionsCount ?? 0))
        let totalUserPosts = Double((user.answersCount ?? 0) + (user.questionsCount ?? 0))
        cell.percentageLabel.emphasize(text: String(format: "%.2f", max(totalPosts / totalUserPosts * 100.0, 0.01)) + " %")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = UserTaggedPostsViewController(for: user, tagName: data[indexPath.row].tagName!)
        navigationController?.show(vc, sender: nil)
    }
    
    override func showAllData() {
        let vc = TagsViewController(for: user)
        navigationController?.show(vc, sender: nil)
    }
}

extension TopTagsViewController: RemoteDataSource {
    var endpoint: String {
        return "users/\(user.id!)/top-tags"
    }
    
    var parameters: [ParametersConvertible] {
        return []
    }
}
