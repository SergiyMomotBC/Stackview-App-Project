//
//  TagsSearchViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/31/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

class TagsSearchViewController: SearchViewController<Tag, TagTableViewCell> {
    init() {
        super.init(for: .tag, searchPrompt: "Search tags...")
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let questionsVC = QuestionsViewController(for: data[indexPath.row])
        navigationController?.show(questionsVC, sender: nil)
    }
}

extension TagsSearchViewController: RemoteDataSource {
    var endpoint: String {
        return "tags"
    }
    
    var parameters: [ParametersConvertible] {
        return [SortingParameters(option: TagsSortOption.popular(min: nil, max: nil), order: .descending), InnameSearchParameter(query: searchbar.text!)]
    }
}
