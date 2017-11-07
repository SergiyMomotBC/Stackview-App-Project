//
//  QuestionViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/20/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import StatefulViewController
import NotificationCenter
import CFAlertViewController

class QuestionDetailViewController: TabBarController {
    var question: Question!
    var answerID: Int?
    var questionID: String
    let api = StackExchangeRequest()
    var saveVisitToCoreData: Bool = true
    
    private let authenticatedFilter = "!OtvHwNa-xYCjKDQ9mBGgy.YQSZNyrXg0o9MdMty5C)F"
    private let unauthenticatedFilter = "!X31uym0GeDsFiB124EStt3WoY-.zNR8XqdojLjc"
    
    weak var questionViewController: QuestionPostViewController?
    weak var answersViewController: AnswersViewController?
    
    init(for questionID: String, answerIDToPresentFirst: Int? = nil, saveVisit: Bool = true) {
        self.saveVisitToCoreData = saveVisit
        self.questionID = questionID
        self.answerID = answerIDToPresentFirst
        super.init()
    }
    
    init(forAnswerID answerID: String) {
        self.answerID = Int(answerID)
        self.questionID = "-1"
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hasContent() -> Bool {
        return question != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: AuthenticatedUser.userAuthenticatedNotificationName), object: nil)
        
        loadData {
            let questionViewController = QuestionPostViewController(for: self.question)
            let answersViewController = AnswersViewController(for: self.question.answers ?? [], answerID: self.answerID)
            let relatedViewController = RelatedQuestionsViewController(for: self.questionID)
            self.setViewControllers([questionViewController, answersViewController, relatedViewController], initialIndex: self.answerID == nil ? 0 : 1)
            self.questionViewController = questionViewController
            self.answersViewController = answersViewController
            
            if self.saveVisitToCoreData {
                CoreDataManager.shared.addBrowsingRecord(id: self.question.id!, title: self.question.title!, tags: self.question.tags!)
            }
        }
    }
    
    override func tabSelected() {
        super.tabSelected()
        if tabBar.selectedSegmentIndex < 2 {
            let reloadButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reload))
            navigationController?.navigationBar.topItem?.rightBarButtonItems?.append(reloadButton)
        }
    }
    
    @objc func reload() {
        question = nil
        answerID = nil
        
        loadData {
            self.questionViewController?.update(for: self.question)
            self.answersViewController?.update(for: self.question!.answers ?? [])
        }
    }
    
    func loadData(showLoader: Bool = true, completion: (() -> Void)?) {
        tabBar.isHidden = true
        
        if showLoader {
            startLoading()
        }
        
        api.filterName = AuthenticatedUser.current.accessToken == nil ? unauthenticatedFilter : authenticatedFilter
        api.makeRequest(to: questionID != "-1" ? "questions/\(questionID)" : "answers/\(answerID!)/questions") { (results: [Question]?, error: RequestError?, _) in
            if let requestError = error, self.question == nil {
                switch requestError {
                case .noInternetConnection:
                    self.endLoading(animated: true, error: ErrorType.noConnection, completion: nil)
                default:
                    self.endLoading(animated: true, error: ErrorType.other, completion: nil)
                }
            } else if let resultQuestion = results?.first {
                self.question = resultQuestion
                self.questionID = String(self.question.id!)
                self.tabBar.isHidden = false
                completion?()
                self.endLoading(animated: true, error: nil, completion: nil)
            } else {
                let alert = CFAlertViewController(title: "Question is not found", titleColor: .mainAppColor,
                                                  message: "This question was deleted or does not exist.", messageColor: .flatBlack,
                                                  textAlignment: .left, preferredStyle: .alert, headerView: nil, footerView: nil,
                                                  didDismissAlertHandler: { _ in self.navigationController?.popViewController(animated: true) })
                
                alert.addAction(CFAlertAction(title: "OK", style: .Default, alignment: .justified, backgroundColor: .flatRed, textColor: .white, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
