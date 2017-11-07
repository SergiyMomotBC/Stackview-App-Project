//
//  BrowsingRecordSectionHeaderView.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/29/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class BrowsingRecordSectionHeaderView: UITableViewHeaderFooterView {
    let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.mainAppColor
        
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .white
        contentView.addSubview(line)
        line.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        line.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        
        textLabel?.textColor = .white
        textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        contentView.addSubview(deleteButton)
        deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0.0).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
