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
    let navigationSearchbar: NavigationSearchbar
    let type: SearchRecordType
    var allowEmptyStringSearch = false
    var firstAppearance = true
    
    override var emptyStateImage: UIImage {
        return UIImage(named: "search_empty_state")!
    }
    
    init(for type: SearchRecordType, searchPrompt: String, showCancelButton: Bool = true) {
        self.type = type
        self.recentSearchesTableView = RecentSearchesTableView(for: type)
        self.navigationSearchbar = NavigationSearchbar(placeholder: searchPrompt, showCancelButton: showCancelButton)
        
        super.init(nibName: nil, bundle: nil)
        
        if showCancelButton {
            navigationSearchbar.cancelButton.addTarget(self, action: #selector(cancelSearch), for: .touchUpInside)
        }
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
        if #available(iOS 11.0, *) {
            recentSearchesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            recentSearchesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            recentSearchesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            recentSearchesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            recentSearchesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            recentSearchesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            recentSearchesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            recentSearchesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        
        recentSearchesTableView.recordSelectedHandler = { [weak self] (query: String) in
            if let controller = self {
                controller.navigationSearchbar.searchbar.text = query
                controller.performSearch()
            }
        }

        navigationSearchbar.searchbar.inputAccessoryView = InputAccessoryButton(title: "Hide") { [weak self] in
            self?.navigationSearchbar.searchbar.endEditing(true)
        }
        
        navigationItem.titleView = navigationSearchbar
        navigationItem.hidesBackButton = true
        navigationSearchbar.searchbar.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if firstAppearance {
            navigationSearchbar.searchbar.becomeFirstResponder()
            firstAppearance = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        navigationSearchbar.searchbar.endEditing(true)
    }
    
    func showResultsTableView() {
        recentSearchesTableView.isHidden = true
        tableView.isHidden = false
        view.sendSubview(toBack: recentSearchesTableView)
    }
    
    func showRecentsTableView() {
        tableView.isHidden = true
        recentSearchesTableView.reloadData()
        recentSearchesTableView.isHidden = false
        view.bringSubview(toFront: recentSearchesTableView)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showRecentsTableView()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !data.isEmpty {
            showResultsTableView()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isSameSearch = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !isSameSearch && (allowEmptyStringSearch || !textField.text!.isEmpty) {
            performSearch()
        }
        return true
    }
    
    func performSearch() {
        navigationSearchbar.endEditing(true)
        showResultsTableView()
        if !navigationSearchbar.searchbar.text!.isEmpty {
            CoreDataManager.shared.addRecord(title: navigationSearchbar.searchbar.text!, type: type)
        }
        data.removeAll()
        loadData()
        isSameSearch = true
    }
    
    override func hasContent() -> Bool {
        return data.count > 0
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        navigationSearchbar.searchbar.endEditing(true)
    }
    
    @objc private func cancelSearch() {
        navigationController?.popViewController(animated: true)
    }
}
