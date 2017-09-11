//
//  StateDisplayView.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/24/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class StateDisplayView: UIView {
    private let loaderSize: CGFloat = 60
    
    init(backgroundColor: UIColor, loaderColor: UIColor) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        
        let loadingCircle = DGElasticPullToRefreshLoadingViewCircle(lineWidth: 3.0)
        loadingCircle.translatesAutoresizingMaskIntoConstraints = false
        loadingCircle.tintColor = loaderColor
        loadingCircle.widthAnchor.constraint(equalToConstant: loaderSize).isActive = true
        loadingCircle.heightAnchor.constraint(equalToConstant: loaderSize).isActive = true
        loadingCircle.setPullProgress(1.0)
        loadingCircle.startAnimating()
        
        addSubview(loadingCircle)
        loadingCircle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loadingCircle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    init(backgroundColor: UIColor, image: UIImage, message: String) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(containerView)
        containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1.5).isActive = true
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        let imageView = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        containerView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12.0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12.0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12.0).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0).isActive = true
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = message
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        label.textAlignment = .center
        containerView.addSubview(label)
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12.0).isActive = true
        label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
