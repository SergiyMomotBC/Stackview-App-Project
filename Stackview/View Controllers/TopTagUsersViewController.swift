//
//  TopTagUsersViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/18/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

fileprivate enum Period: String {
    case allTime = "all_time"
    case month
}

class TopTagUsersViewController: DataPresenterViewController<TagScore, TagScoreTableViewCell> {
    let isAskers: Bool
    let tagName: String
    private var period: Period = .allTime
    
    init(tagName: String, forAskers isAskers: Bool) {
        self.isAskers = isAskers
        self.tagName = tagName
        super.init(nibName: nil, bundle: nil)
        dataSource = self
        title = "Top users in \(tagName)"
        dropDownItems = ["All time", "Last 30 days"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 0.0
        tableView.rowHeight = 120.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func handleDropDownSelection(for index: Int) {
        switch index {
        case 0:
            period = .allTime
        case 1:
            period = .month
        default:
            fatalError()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! TagScoreTableViewCell
        
        let posts = data[indexPath.row].postsCount ?? 0
        let post = isAskers ? "question" : "answer"
        cell.postsLabel.emphasize(text: "\(posts.toString()) \(post)" + (abs(posts) != 1 ? "s" : ""))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = UserProfileViewController(for: String(data[indexPath.row].user!.id ?? 0))
        navigationController?.show(vc, sender: nil)
    }
}

extension TopTagUsersViewController: RemoteDataSource {
    var endpoint: String {
        return "tags/\(tagName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)/\(isAskers ? "top-askers" : "top-answerers")/\(period.rawValue)"
    }
    
    var parameters: [ParametersConvertible] {
        return []
    }
}

extension TopTagUsersViewController: Tabbable {
    var icon: UIImage {
        return isAskers ? UIImage(named: "top_askers_icon")!.withRenderingMode(.alwaysTemplate) : UIImage(named: "top_answerers_icon")!.withRenderingMode(.alwaysTemplate)
    }
    
    var iconTitle: String {
        return isAskers ? "Top askers" : "Top answerers"
    }
}
