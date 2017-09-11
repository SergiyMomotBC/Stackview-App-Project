//
//  TagWikiViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/8/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import WebKit

class TagWikiViewController: UIViewController {
    private let htmlBodyText: String
    
    lazy var webView: WKWebView = {
        let view = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -8.0)
        view.scrollView.clipsToBounds = false
        view.navigationDelegate = self
        return view
    }()
    
    init(for wikiBody: String) {
        self.htmlBodyText = wikiBody
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView(frame: .zero)
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        self.title = "Tag wiki"
        super.viewDidLoad()
        
        view.addSubview(webView)
        webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4.0).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4.0).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let path = Bundle.main.path(forResource: "style", ofType: "css") else { return }
        let cssSource = try? String(contentsOfFile: path).trimmingCharacters(in: .whitespacesAndNewlines)
        
        webView.loadHTMLString("<head><style type=\"text/css\">\(cssSource ?? "")</style></head>\n" + htmlBodyText, baseURL: nil)
    }
}

extension TagWikiViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let openURL = navigationAction.request.url {
            UIApplication.shared.open(openURL, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
