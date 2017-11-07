//
//  CodeViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/27/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import NotificationCenter

class CodeViewController: UIViewController {
    private static let cssSource = """
                                        html {
                                            background-color: #eff0f1;
                                            -webkit-text-size-adjust: none;
                                        }

                                        pre {
                                            font-size: 100%;
                                            background-color: #eff0f1;
                                            font-family: Consolas, monospace, sans-serif;
                                            -webkit-overflow-scrolling: touch;
                                            overflow: scroll;
                                        }
                                   """
    
    private let codeHTML: String
    private let codeWebView = PostWebView(cssToUse: CodeViewController.cssSource)
    
    var codeWebViewHeightConstraint: NSLayoutConstraint!
    var codeWebViewWidthConstraint: NSLayoutConstraint!
    
    init(for codeHTML: String) {
        self.codeHTML = codeHTML
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rotate), name: .UIDeviceOrientationDidChange, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func rotate() {
        var rotationAngle: CGFloat
        
        switch UIDevice.current.orientation {
        case .portrait:
            rotationAngle = 0.0
            codeWebViewHeightConstraint.constant = view.frame.height
            codeWebViewWidthConstraint.constant = view.frame.width
        case .landscapeLeft:
            rotationAngle = .pi / 2
            codeWebViewHeightConstraint.constant = view.frame.width
            codeWebViewWidthConstraint.constant = view.frame.height
        case .landscapeRight:
            rotationAngle = -(.pi / 2)
            codeWebViewHeightConstraint.constant = view.frame.width
            codeWebViewWidthConstraint.constant = view.frame.height
        case .portraitUpsideDown:
            rotationAngle = .pi
            codeWebViewHeightConstraint.constant = view.frame.height
            codeWebViewWidthConstraint.constant = view.frame.width
        default:
            return
        }
        
        UIView.animate(withDuration: 0.33) {
            self.view.layoutIfNeeded()
            self.codeWebView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainAppColor
        navigationItem.title = "Code snippet"
        
        view.addSubview(codeWebView)
        
        codeWebView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        codeWebView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        codeWebViewWidthConstraint = codeWebView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        codeWebViewWidthConstraint.isActive = true
        codeWebViewHeightConstraint = codeWebView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height - UIApplication.shared.statusBarFrame.height - 44.0)
        codeWebViewHeightConstraint.isActive = true
        
        codeWebView.loadHTML(string: "<meta name=\"viewport\" id=\"viewport\" content=\"width=device-width,user-scalable=no\" />" + "<pre>" + self.codeHTML + "</pre>")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
