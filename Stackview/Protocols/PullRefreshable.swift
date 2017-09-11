//
//  PullRefreshable.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/24/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

protocol PullRefreshable {}

extension PullRefreshable where Self: DataViewController {
    func enablePullToRefresh(for tableView: UIScrollView, backgroundColor: UIColor, handler: @escaping () -> Void) {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = .white
        
        tableView.dg_addPullToRefreshWithActionHandler({ handler() }, loadingView: loadingView)
        tableView.dg_setPullToRefreshBackgroundColor(backgroundColor)
        tableView.dg_setPullToRefreshFillColor(.mainAppColor)
    }
}
