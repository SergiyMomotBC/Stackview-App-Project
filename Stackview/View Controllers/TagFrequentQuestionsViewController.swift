//
//  TagFrequentQuestionsViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/7/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class TagFrequentQuestionsViewController: DataPresenterViewController<Question, QuestionTableViewCell> {
    let tagName: String
    
    init(for tagName: String) {
        self.tagName = tagName
        super.init(nibName: nil, bundle: nil)
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.title = "Frequent questions"
        self.dropDownItems = [self.tagName]
        
        super.viewDidLoad()
    }
}

extension TagFrequentQuestionsViewController: RemoteDataSource {
    var endpoint: String {
        return "tags/\(self.tagName)/faq"
    }
    
    var parameters: [ParametersConvertible] {
        return []
    }
}
