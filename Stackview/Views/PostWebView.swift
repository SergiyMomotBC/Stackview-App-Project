//
//  PostWebView.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/27/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import WebKit
import DGElasticPullToRefresh

class PostWebView: WKWebView {
    private static let cssSource = try! String(contentsOfFile: Bundle.main.path(forResource: "main", ofType: "css")!).trimmingCharacters(in: .whitespacesAndNewlines)
    
    let codeSelectableScriptSource = """
                                        var elements = document.getElementsByTagName('pre');
                                        for(var i = 0; i < elements.length; i++) {
                                            elements[i].onclick = function() {
                                                webkit.messageHandlers.\(PostWebView.codeSelectedHandlerName).postMessage(this.innerHTML);
                                            }
                                        }
                                        var elements = document.getElementsByTagName('img');
                                        for(var i = 0; i < elements.length; i++) {
                                            elements[i].onclick = function() {
                                                webkit.messageHandlers.\(PostWebView.imageSelectedHandlerName).postMessage(this.src);
                                            }
                                        }
                                    """

    private static let codeSelectedHandlerName = "codeSelectedHandler"
    private static let imageSelectedHandlerName = "imageSelectedHandler"
    
    weak var linkHandler: LinkHandler?
    weak var selectedCodeHandler: SelectedCodeHandler?
    weak var selectedImageHandler: SelectedImageHandler?
    private let cssSource: String
    
    lazy var activityIndicator: DGElasticPullToRefreshLoadingViewCircle = {
        let activity = DGElasticPullToRefreshLoadingViewCircle(lineWidth: 2.0)
        activity.tintColor = .mainAppColor
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.setPullProgress(1.0)
        activity.widthAnchor.constraint(equalToConstant: 36.0).isActive = true
        activity.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        return activity
    }()
    
    init(cssToUse: String = PostWebView.cssSource) {
        self.cssSource = cssToUse
        
        let contentController = WKUserContentController()
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        super.init(frame: .zero, configuration: config)
        translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = false
        navigationDelegate = self
        
        let script = WKUserScript(source: codeSelectableScriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(script)
        
        contentController.add(self, name: PostWebView.codeSelectedHandlerName)
        contentController.add(self, name: PostWebView.imageSelectedHandlerName)
        
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadHTML(string: String) {
        let header = "<head>" +
                     "<style type=\"text/css\">\(self.cssSource)</style>" +
                     "<script src=\"https://cdn.rawgit.com/google/code-prettify/master/loader/run_prettify.js\"></script>" +
                     "</head>"
        
        //for Google Code Prettify
        let html = string.replacingOccurrences(of: "<pre><code>", with: "<pre class=\"prettyprint-override\"><code>")
        
        loadHTMLString(header + html, baseURL: nil)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
}

extension PostWebView: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == PostWebView.codeSelectedHandlerName, let codeHTML = message.body as? String {
            selectedCodeHandler?.handleCode(codeHTML)
        } else if message.name == PostWebView.imageSelectedHandlerName, let imageURL = message.body as? String {
            selectedImageHandler?.handleImageURL(imageURL)
        }
    }
}

extension PostWebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            let urlToOpen = navigationAction.request.url!
            linkHandler?.handleURL(urlToOpen)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopLoading()
        activityIndicator.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopLoading()
        activityIndicator.isHidden = true
    }
}
