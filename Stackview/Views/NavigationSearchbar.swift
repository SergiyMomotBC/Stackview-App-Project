//
//  NavigationSearchbar.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/25/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class NavigationSearchbar: UIView {
    let searchbar: SearchbarTextfield
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        return button
    }()
    
    init(placeholder: String?, showCancelButton: Bool = true) {
        searchbar = SearchbarTextfield(placeholder: placeholder)
        
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: SearchbarTextfield.preferredHeight + 8.0))
        autoresizingMask = .flexibleWidth
        
        if showCancelButton {
            addSubview(cancelButton)
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            cancelButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            cancelButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
        
        addSubview(searchbar)
        searchbar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        searchbar.topAnchor.constraint(equalTo: topAnchor, constant: 4.0).isActive = true
        searchbar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.0).isActive = true
        searchbar.trailingAnchor.constraint(equalTo: showCancelButton ? cancelButton.leadingAnchor : trailingAnchor,
                                            constant: showCancelButton ? -8.0 : 0.0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: SearchbarTextfield.preferredHeight + 8.0)
    }
}

class SearchbarTextfield: UITextField {
    static let preferredHeight: CGFloat = 36.0
    private var sideViewsPadding: CGFloat = 0.0
    
    init(placeholder: String?) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        textColor = .white
        autocorrectionType = .no
        font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        returnKeyType = .search
        keyboardAppearance = .dark
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "Search...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        borderStyle = .roundedRect
        
        let image = UIImageView(image: UIImage(named: "search_icon")!.withRenderingMode(.alwaysTemplate))
        image.contentMode = .scaleAspectFit
        image.tintColor = .white
        
        leftViewMode = .always
        leftView = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sideViewsPadding = frame.height * 0.2
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let size = frame.height - 2.0 * sideViewsPadding
        return CGRect(x: 2, y: sideViewsPadding, width: size + 12.0, height: size)
    }
}
