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
    var isPagingEnabled = true
    var loadMoreView = BottomLoadingView(frame: CGRect(x: 0, y: 0, width: 1, height: 50))
    var loaderColor = UIColor.white
    var loaderBackgroundColor = UIColor.mainAppColor
    
    var emptyStateImage: UIImage {
        return UIImage(named: "no_content_empty_state")!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emptyView = StateDisplayView(backgroundColor: UIColor.mainAppColor, image: emptyStateImage, message: "No content found.", retriable: false)
        errorView = StateDisplayView(backgroundColor: UIColor.mainAppColor, image: UIImage(named: "response_error")!, message: "Something went terribly wrong.")
        connectionErrorView = StateDisplayView(backgroundColor: UIColor.mainAppColor, image: UIImage(named: "no_internet_error")!, message: "Very slow or no Internet connection.")
        loadingView = StateDisplayView(backgroundColor: loaderBackgroundColor, loaderColor: loaderColor)
    }
    
    func hasContent() -> Bool {
        return true
    }
}
