//
//  InboxItemsViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 10/17/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class InboxItemsViewController: DataPresenterViewController<InboxItem, InboxItemTableViewCell> {
    private var lastSeenInboxItemDate = 0.0
    
    override var emptyStateImage: UIImage {
        return UIImage(named: "no_messages_empty_state")!
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        dataSource = self
        navigationItem.title = "Inbox items"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func processDataBeforePresenting() {
        self.data = data.filter({ !($0.bodyText ?? "").isEmpty })
        
        if self.data.count <= paging.pageSize {
            lastSeenInboxItemDate = UserDefaults.standard.double(forKey: "lastSeenInboxItemDate")
            if let firstInboxItemDate = data.first?.creationDate {
                UserDefaults.standard.set(firstInboxItemDate.timeIntervalSince1970, forKey: "lastSeenInboxItemDate")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
        
        cell.contentView.subviews.first?.backgroundColor = (data[indexPath.row].isUnread ?? false) &&
            Date(timeIntervalSince1970: lastSeenInboxItemDate) < data[indexPath.row].creationDate!
            ? .unreadColor : .white
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let item = data[indexPath.row]
        return item.questionID == nil && item.answerID == nil && item.commentID == nil ? nil : indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var vc: UIViewController
        if let answerID = data[indexPath.row].answerID {
            vc = QuestionDetailViewController(forAnswerID: String(answerID))
        } else {
            vc = QuestionDetailViewController(for: String(data[indexPath.row].questionID ?? 0))
        }
        
        navigationController?.show(vc, sender: nil)
    }
}

extension InboxItemsViewController: RemoteDataSource {
    var endpoint: String {
        return "me/inbox"
    }
    
    var parameters: [ParametersConvertible] {
        return []
    }
}

extension InboxItemsViewController: Tabbable {
    var icon: UIImage {
        return UIImage(named: "inbox_item_icon")!.withRenderingMode(.alwaysTemplate)
    }
    
    var iconTitle: String {
        return "Messages"
    }
}
