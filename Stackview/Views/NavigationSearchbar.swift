//
//  NavigationSearchbar.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/25/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class NavigationSearchbar: UITextField {
    private var sideViewsPadding: CGFloat = 4.0
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 1000, height: 28)
    }
    
    init(placeholder: String?) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        textColor = .white
        autocorrectionType = .no
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
        return CGRect(x: sideViewsPadding, y: sideViewsPadding, width: size, height: size)
    }
}
