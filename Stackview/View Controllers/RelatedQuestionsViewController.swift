//
//  RelatedQuestionsViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/27/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class RelatedQuestionsViewController: DataPresenterViewController<Question, QuestionTableViewCell> {
    let questionID: String
    
    init(for questionID: String) {
        self.questionID = questionID
        super.init(nibName: nil, bundle: nil)
        dataSource = self
        navigationItem.title = "Related questions"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = QuestionDetailViewController(for: String(data[indexPath.row].id!))
        navigationController?.show(vc, sender: nil)
    }
}

extension RelatedQuestionsViewController: RemoteDataSource {
    var endpoint: String {
        return "questions/\(questionID)/related"
    }
    
    var parameters: [ParametersConvertible] {
        return [SortingParameters(option: QuestionsRankedSortOption.rank, order: .descending)]
    }
}

extension RelatedQuestionsViewController: Tabbable {
    var icon: UIImage {
        return UIImage(named: "related_icon")!.withRenderingMode(.alwaysTemplate)
    }
    
    var iconTitle: String {
        return "Related"
    }
}
