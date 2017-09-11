//
//  TagQuickInfoViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/7/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import StatefulViewController

class TagQuickInfoViewController: DataViewController {
    private let api = StackExchangeRequest()
    private let tagName: String
    var tagWiki: TagWiki?
    
    lazy var tagNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textAlignment = .center
        label.textColor = UIColor.secondaryAppColor
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        label.numberOfLines = 1
        return label
    }()
    
    lazy var textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isEditable = false
        view.textAlignment = .natural
        view.font = UIFont.systemFont(ofSize: 14.0)
        view.textColor = UIColor.black
        return view
    }()
    
    init(for tagName: String) {
        self.tagName = tagName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 260))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        view.addSubview(tagNameLabel)
        tagNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0).isActive = true
        tagNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
        tagNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0).isActive = true
        
        view.addSubview(textView)
        textView.topAnchor.constraint(equalTo: tagNameLabel.bottomAnchor, constant: 8.0).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20.0).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        api.makeRequest(to: "tags/\(tagName)/wikis".addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!) { (wikis: [TagWiki]?, error: RequestError?, _) in
            if let requestError = error {
                switch requestError {
                case .noInternetConnection:
                    self.endLoading(animated: true, error: ErrorType.noConnection, completion: nil)
                default:
                    self.endLoading(animated: true, error: ErrorType.other, completion: nil)
                }
            } else {
                self.tagWiki = wikis?.first

                self.tagNameLabel.text = self.tagWiki?.tagName
                self.textView.text = "\t" + (self.tagWiki?.excerptText?.htmlUnescape() ?? "No information available about this tag.")
                
                self.endLoading(animated: true, error: nil, completion: nil)
            }
        }
    }
    
    override func hasContent() -> Bool {
        return tagWiki != nil
    }
}

