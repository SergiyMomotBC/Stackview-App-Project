//
//  BadgesViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/1/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import CFAlertViewController

class BadgesViewController: DataPresenterViewController<Badge, BadgeTableViewCell> {
    static func showBadgeDescription(_ badge: Badge, in vc: UIViewController) {
        let description = (badge.description?.htmlUnescape().removingHREF() ?? "No description") + "."
        
        let alert = CFAlertViewController(title: badge.name?.htmlUnescape(), titleColor: .mainAppColor, message: description, messageColor: .flatBlack,
                                          textAlignment: .left, preferredStyle: .alert, headerView: nil, footerView: nil, didDismissAlertHandler: nil)
        
        alert.addAction(CFAlertAction(title: "OK", style: .Default, alignment: .justified, backgroundColor: .flatPurple, textColor: .white, handler: nil))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    private var sortingOption: UserBadgesSortOption = .awarded
    private var user: User
    
    init(for user: User) {
        self.user = user
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = user.name! + "'s badges"
        self.dropDownItems = ["Recent", "Gold", "Silver", "Bronze"]
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func handleDropDownSelection(for index: Int) {
        switch index {
        case 0:
            sortingOption = .awarded
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        BadgesViewController.showBadgeDescription(data[indexPath.row], in: self)
    }
}

extension BadgesViewController: RemoteDataSource {
    var endpoint: String {
        return "users/\(user.id!)/badges"
    }
    
    var parameters: [ParametersConvertible] {
        return [SortingParameters(option: sortingOption, order: .descending)]
    }
}
