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
    var loadFinished: (() -> Void)?
    
    lazy var tagNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 28.0)
        label.textAlignment = .center
        label.textColor = UIColor.flatPurple
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        label.numberOfLines = 1
        return label
    }()
    
    lazy var synonymsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        label.text = "Synonyms:"
        label.isHidden = true
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
    
    let tagsCollectionView = TagsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    init(for tagName: String) {
        self.tagName = tagName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
    }
    
    override func viewDidLoad() {
        loaderColor = .mainAppColor
        loaderBackgroundColor = .white
        
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
        
        view.addSubview(synonymsLabel)
        synonymsLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 4.0).isActive = true
        synonymsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26.0).isActive = true
        
        view.addSubview(tagsCollectionView)
        tagsCollectionView.topAnchor.constraint(equalTo: synonymsLabel.bottomAnchor, constant: 4.0).isActive = true
        tagsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26.0).isActive = true
        tagsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26.0).isActive = true
        tagsCollectionView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        tagsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        loadTagData()
    }
    
    func loadTagData() {
        startLoading(animated: false, completion: nil)
        
        api.makeRequest(to: "tags/\(tagName)/wikis".addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!) { (wikis: [TagWiki]?, error: RequestError?, _) in
            if let requestError = error {
                switch requestError {
                case .noInternetConnection:
                    self.endLoading(animated: true, error: ErrorType.noConnection, completion: nil)
                default:
                    self.endLoading(animated: true, error: ErrorType.other, completion: nil)
                }
            } else {
                self.api.makeRequest(to: "tags/\(self.tagName)/info".addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!) { (info: [Tag]?, error: RequestError?, _) in
                    self.tagWiki = wikis?.first
                    
                    self.tagNameLabel.text = self.tagWiki?.tagName
                    self.textView.text = "\t" + (self.tagWiki?.excerptText?.htmlUnescape() ?? "No information available about this tag.")
                    
                    var height = 30 + self.tagNameLabel.intrinsicContentSize.height + self.textView.contentSize.height
                    
                    if let synonyms = info?.first?.synonyms {
                        self.tagsCollectionView.tagNames = synonyms
                        self.synonymsLabel.isHidden = false
                        height += 38 + self.synonymsLabel.intrinsicContentSize.height
                    } else {
                        self.synonymsLabel.removeFromSuperview()
                        self.tagsCollectionView.removeFromSuperview()
                        self.textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
                    }
                    
                    self.view.frame = CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.frame.width, height: height))
                    
                    self.endLoading(animated: false, error: nil, completion: nil)
                    self.loadFinished?()
                }
            }
        }
    }
    
    override func hasContent() -> Bool {
        return tagWiki != nil
    }
}

