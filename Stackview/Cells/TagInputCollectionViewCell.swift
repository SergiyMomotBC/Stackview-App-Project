//
//  TagInputCollectionViewCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/9/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class TagInputCollectionViewCell: UICollectionViewCell {
    var textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = .clear
        field.font = UIFont.systemFont(ofSize: 16.0)
        field.textColor = .white
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.keyboardAppearance = .dark
        field.returnKeyType = .done
        field.tintColor = .white
        return field
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(textField)
        textField.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
