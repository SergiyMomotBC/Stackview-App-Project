//
//  BottomLoadingView.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/23/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class BottomLoadingView: UIView {
    private let activityView = DGElasticPullToRefreshLoadingViewCircle(lineWidth: 2.0)
    
    override init(frame: CGRect) {
        activityView.tintColor = .white
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.setPullProgress(1.0)
        
        super.init(frame: frame)
        
        addSubview(activityView)
        activityView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityView.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        activityView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        isHidden = true
    }
    
    func enable() {
        isHidden = false
        activityView.startAnimating()
    }
    
    func disable() {
        isHidden = true
        activityView.stopLoading()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

