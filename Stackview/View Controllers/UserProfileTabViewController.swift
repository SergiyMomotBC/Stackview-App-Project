//
//  UserProfileTabViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/13/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class UserProfileTabViewController<DataType, CellType: GenericCell<DataType>>: DataPresenterViewController<DataType, CellType> {
    private var isLoaded = false
    var buttonTitleText = ""
    weak var scrollDelegate: UserProfileTabViewControllerDelegate?

    override func viewDidLoad() {
        shouldEnablePullToRefresh = false
        shouldLoadOnInit = false
        isPagingEnabled = false
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isLoaded {
            isLoaded = true
            loadData()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
        
        scrollDelegate?.scrollViewDidScroll(scrollView)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .mainAppColor
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(buttonTitleText, for: .normal)
        button.setTitleColor(.flatRed, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        button.addTarget(self, action: #selector(showAllData), for: .touchUpInside)
        
        header.addSubview(button)
        button.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16.0).isActive = true
        button.topAnchor.constraint(equalTo: header.topAnchor, constant: 4.0).isActive = true
        button.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -4.0).isActive = true
        
        return header
    }
    
    @objc func showAllData() {}
}
