//
//  NotificationsViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 10/17/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class NotificationsViewController: DataPresenterViewController<Notification, NotificationTableViewCell> {
    private var lastSeenNotificationDate = 0.0
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
    }
    
    override func processDataBeforePresenting() {
        self.data = self.data.filter({ !($0.bodyText ?? "").isEmpty })
        
        if self.data.count <= paging.pageSize {
            lastSeenNotificationDate = UserDefaults.standard.double(forKey: "lastSeenNotificationDate")
            if let firstNotificationDate = self.data.first?.creationDate {
                UserDefaults.standard.set(firstNotificationDate.timeIntervalSince1970, forKey: "lastSeenNotificationDate")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
        
        cell.contentView.subviews.first?.backgroundColor = (data[indexPath.row].isUnread ?? false) &&
            Date(timeIntervalSince1970: lastSeenNotificationDate) < data[indexPath.row].creationDate!
            ? .unreadColor : .white
    }
}

extension NotificationsViewController: RemoteDataSource {
    var endpoint: String {
        return "me/notifications"
    }
    
    var parameters: [ParametersConvertible] {
        return []
    }
}

extension NotificationsViewController: Tabbable {
    var icon: UIImage {
        return UIImage(named: "notifications_icon")!.withRenderingMode(.alwaysTemplate)
    }
    
    var iconTitle: String {
        return "Notifications"
    }
}
