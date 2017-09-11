//
//  TagInputCollectionViewCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/9/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class TagInputCollectionViewCell: UICollectionViewCell {
    private let textColor = UIColor.white
    
    var textField: UITextField
    
    override init(frame: CGRect) {
        textField = UITextField()
        
        super.init(frame: frame)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.textColor = textColor
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardAppearance = .dark
        textField.returnKeyType = .done
        textField.tintColor = .white
        
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
