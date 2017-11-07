//
//  QuestionsSearchViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/31/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class PostsSearchViewController: SearchViewController<SearchExcerpt, SearchExcerptTableViewCell> {
    let sortingParameters = SortingParameters(option: RelevantQuestionsSortOption.relevance, order: .descending)
    var searchParameters = SearchParameters()
    
    lazy var filterController = PostsFilterOptionsViewController()
    
    init(dissmisable: Bool = false) {
        super.init(for: .post, searchPrompt: "Search posts...", showCancelButton: dissmisable)
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        allowEmptyStringSearch = true
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter_icon")!.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(showFilterOptions))
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let post = data[indexPath.row]
        if post.itemType! == .question {
            let vc = QuestionDetailViewController(for: String(post.questionID!))
            navigationController?.show(vc, sender: nil)
        } else {
            let vc = QuestionDetailViewController(for: String(post.questionID!), answerIDToPresentFirst: post.answerID)
            navigationController?.show(vc, sender: nil)
        }
    }
    
    @objc private func showFilterOptions() {
        filterController.searchOptions = searchParameters
        filterController.delegate = self
        navigationController?.show(filterController, sender: nil)
    }
}

extension PostsSearchViewController: RemoteDataSource {
    var endpoint: String {
        return "search/excerpts"
    }
    
    var parameters: [ParametersConvertible] {
        searchParameters.query = navigationSearchbar.searchbar.text
        return [searchParameters, sortingParameters]
    }
}

extension PostsSearchViewController: PostsFilterOptionsDelegate {
    func shouldApplyOptions(_ options: SearchParameters) {
        if tableView.isHidden {
            showResultsTableView()
        }
        
        self.searchParameters = options
        data.removeAll()
        loadData(showLoader: true)
    }
}
