//
//  DataViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/22/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import StatefulViewController

class DataViewController: UIViewController, StatefulViewController {
    var paging = PagingParameters(pageSize: 40)
    var loading = false
    var loadMoreView = BottomLoadingView(frame: CGRect(x: 0, y: 0, width: 1, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emptyView = StateDisplayView(backgroundColor: UIColor.mainAppColor, image: UIImage(named: "no_results")!, message: "We could not find what you were looking for.")
        errorView = StateDisplayView(backgroundColor: UIColor.mainAppColor, image: UIImage(named: "error")!, message: "We tried, but something went terribly wrong.")
        connectionErrorView = StateDisplayView(backgroundColor: UIColor.mainAppColor, image: UIImage(named: "no_connection")!, message: "Very slow or no Internet connection.")
        loadingView = StateDisplayView(backgroundColor: UIColor.mainAppColor, loaderColor: .white)
    }
    
    func hasContent() -> Bool {
        return true
    }
}
