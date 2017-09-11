//
//  QuestionsSearchViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/31/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class QuestionsSearchViewController: SearchViewController<SearchExcerpt, SearchExcerptTableViewCell> {
    let sortingParameters = SortingParameters(option: RelevantQuestionsSortOption.relevance, order: .descending)
    var searchParameters = SearchParameters()
    
    init() {
        super.init(for: .question, searchPrompt: "Search questions...")
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension QuestionsSearchViewController: RemoteDataSource {
    var endpoint: String {
        return "search/excerpts"
    }
    
    var parameters: [ParametersConvertible] {
        searchParameters.query = searchbar.text
        return [searchParameters, sortingParameters]
    }
}
