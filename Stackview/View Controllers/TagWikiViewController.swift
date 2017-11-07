//
//  TagWikiViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/8/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class TagWikiViewController: UIViewController, LinkHandler, SelectedCodeHandler, SelectedImageHandler {
    private let htmlBodyText: String
    private let edgeOffset: CGFloat = 4.0
    private let webView = PostWebView()
    
    init(for wikiBody: String, tagName: String) {
        self.htmlBodyText = wikiBody
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = "\(tagName) tag info"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.clipsToBounds = true
        
        webView.linkHandler = self
        webView.selectedCodeHandler = self
        webView.selectedImageHandler = self
        webView.scrollView.clipsToBounds = false
        webView.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -edgeOffset)
        
        view.addSubview(webView)
        if #available(iOS 11.0, *) {
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: edgeOffset).isActive = true
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: edgeOffset).isActive = true
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -edgeOffset).isActive = true
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -edgeOffset).isActive = true
        } else {
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: edgeOffset).isActive = true
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: edgeOffset).isActive = true
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: edgeOffset).isActive = true
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: edgeOffset).isActive = true
        }
        
         webView.loadHTML(string: htmlBodyText)
    }
}
