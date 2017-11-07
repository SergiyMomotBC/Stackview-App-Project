//
//  RecentBadgesViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/13/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import CFAlertViewController

class RecentBadgesViewController: UserProfileTabViewController<Badge, BadgeTableViewCell>, Scrollable {
    let user: User
    
    var scrollView: UIScrollView {
        return tableView
    }
    
    init(for user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        dataSource = self
        buttonTitleText = "View all badges"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func showAllData() {
        let vc = BadgesViewController(for: user)
        navigationController?.show(vc, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        BadgesViewController.showBadgeDescription(data[indexPath.row], in: self)
    }
}

extension RecentBadgesViewController: RemoteDataSource {
    var endpoint: String {
        return "users/\(user.id!)/badges"
    }
    
    var parameters: [ParametersConvertible] {
        return [SortingParameters(option: UserBadgesSortOption.awarded, order: .descending)]
    }
}
