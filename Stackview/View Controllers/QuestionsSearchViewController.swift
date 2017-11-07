//
//  QuestionsSearchViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/28/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class QuestionsSearchViewController: SearchViewController<Question, QuestionTableViewCell> {
    init() {
        super.init(for: .question, searchPrompt: "Search questions...")
        dataSource = self
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

extension QuestionsSearchViewController: RemoteDataSource {
    var endpoint: String {
        return "search"
    }
    
    var parameters: [ParametersConvertible] {
        return [SortingParameters(option: RelevantQuestionsSortOption.relevance, order: .descending), IntitleSearchParameter(query: navigationSearchbar.searchbar.text ?? "")]
    }
}
