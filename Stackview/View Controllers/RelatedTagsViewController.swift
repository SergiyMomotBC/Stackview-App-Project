//
//  RelatedTagsViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/18/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class RelatedTagsViewController: DataPresenterViewController<Tag, TagTableViewCell> {
    let tagName: String
    
    init(for tagName: String) {
        self.tagName = tagName
        super.init(nibName: nil, bundle: nil)
        dataSource = self
        title = "Related tags"
        dropDownItems = [tagName]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func processDataBeforePresenting() {
        if let index = self.data.index(where: { $0.name == self.tagName }) {
            self.data.remove(at: index)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let questionsVC = QuestionsViewController(for: data[indexPath.row])
        navigationController?.show(questionsVC, sender: nil)
    }
}

extension RelatedTagsViewController: RemoteDataSource {
    var endpoint: String {
        return "tags/\(tagName)/related"
    }
    
    var parameters: [ParametersConvertible] {
        return []
    }
}
