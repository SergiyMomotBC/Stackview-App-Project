//
//  SearchViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/25/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import StatefulViewController

class SearchViewController<DataType, CellType: GenericCell<DataType>>: DataPresenterViewController<DataType, CellType>, UITextFieldDelegate {
    var isSameSearch = false
    let recentSearchesTableView: RecentSearchesTableView
    let searchbar: NavigationSearchbar
    let type: SearchRecordType
    
    init(for type: SearchRecordType, searchPrompt: String) {
        self.type = type
        self.recentSearchesTableView = RecentSearchesTableView(for: type)
        self.searchbar = NavigationSearchbar(placeholder: searchPrompt)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        shouldLoadOnInit = false
        shouldEnablePullToRefresh = false
        
        super.viewDidLoad()

        tableView.isHidden = true
        
        view.addSubview(recentSearchesTableView)
        recentSearchesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        recentSearchesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        recentSearchesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        recentSearchesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        recentSearchesTableView.recordSelectedHandler = { [weak self] (query: String) in
            if let controller = self {
                controller.searchbar.text = query
                controller.performSearch()
            }
        }

        let holder = UIView(frame: .zero)
        holder.addSubview(searchbar)
        searchbar.topAnchor.constraint(equalTo: holder.topAnchor).isActive = true
        searchbar.leadingAnchor.constraint(equalTo: holder.leadingAnchor, constant: 12.0).isActive = true
        searchbar.trailingAnchor.constraint(equalTo: holder.trailingAnchor, constant: -8.0).isActive = true
        searchbar.bottomAnchor.constraint(equalTo: holder.bottomAnchor).isActive = true
        searchbar.delegate = self
        
        self.navigationItem.titleView = holder
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        searchbar.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" && (textField.text?.count ?? 1) == 1 {
            recentSearchesTableView.reloadData()
            tableView.isHidden = true
            recentSearchesTableView.isHidden = false
        }
        
        isSameSearch = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard !(textField.text?.isEmpty ?? false) && !isSameSearch else { return true }
        performSearch()
        return true
    }
    
    func performSearch() {
        searchbar.endEditing(true)
        recentSearchesTableView.isHidden = true
        tableView.isHidden = false
        CoreDataManager.shared.addRecord(title: searchbar.text!, type: type)
        data.removeAll()
        loadQuestions()
        isSameSearch = true
    }
    
    override func hasContent() -> Bool {
        return data.count > 0 || searchbar.text! == ""
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        searchbar.endEditing(true)
    }
}
