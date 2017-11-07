//
//  QuestionPostViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/25/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class QuestionPostViewController: UIViewController, Tabbable, LinkHandler, SelectedCodeHandler, SelectedImageHandler {
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var userInfoLabel: UserInfoLabel!
    @IBOutlet weak var postedDateLabel: UILabel!
    @IBOutlet weak var scoreLabel: ScoreLabel!
    @IBOutlet weak var webViewContainer: UIView!
    @IBOutlet weak var tagsCollectionView: TagsCollectionView!
    @IBOutlet var editorView: UIStackView!
    @IBOutlet weak var bottomSeparatorView: UIView!
    @IBOutlet weak var editorProfileImageView: ProfileImageView!
    @IBOutlet weak var editorUserInfoLabel: UserInfoLabel!
    @IBOutlet weak var editedDateLabel: UILabel!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentsTableView: CommentsTableView!
    @IBOutlet weak var spaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var favoriteIconImageView: UIImageView!
    @IBOutlet weak var favoritedCountLabel: UILabel!
    @IBOutlet weak var bountyNoticeLabel: PaddedLabel!
    @IBOutlet weak var bountyNoticeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var parentSV: UIStackView!
    
    lazy var contextMenu = ContextMenu(in: self.navigationController!.view)
    var indexPath: IndexPath?
    
    var icon: UIImage {
        return UIImage(named: "question_icon")!.withRenderingMode(.alwaysTemplate)
    }
    
    var iconTitle: String {
        return "Question"
    }
    
    let editorViewHeight: CGFloat = 30.0
    var question: Question
    let bodyWebView = PostWebView()
    
    init(for question: Question) {
        self.question = question
        super.init(nibName: "QuestionPostViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let share = UIBarButtonItem(image: UIImage(named: "more_icon")!.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(contextMenuTapped))
        navigationItem.rightBarButtonItems = [share]
        
        contextMenu.selectionDelegate = self
        
        view.backgroundColor = UIColor.mainAppColor
        mainView.layer.cornerRadius = 6.0
        mainView.clipsToBounds = true
        
        commentsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        commentsButton.titleLabel?.minimumScaleFactor = 0.5
        commentsButton.addTarget(self, action: #selector(didTapCommentsButton(_:)), for: .touchUpInside)
        
        bodyWebView.linkHandler = self
        bodyWebView.selectedCodeHandler = self
        bodyWebView.selectedImageHandler = self
        webViewContainer.addSubview(bodyWebView)
        bodyWebView.topAnchor.constraint(equalTo: webViewContainer.topAnchor).isActive = true
        bodyWebView.leadingAnchor.constraint(equalTo: webViewContainer.leadingAnchor).isActive = true
        bodyWebView.trailingAnchor.constraint(equalTo: webViewContainer.trailingAnchor).isActive = true
        bodyWebView.bottomAnchor.constraint(equalTo: webViewContainer.bottomAnchor).isActive = true
        
        commentsTableView.delegate = self
        commentsTableView.dataSource = self

        bountyNoticeLabel.backgroundColor = .bountyColor
        bountyNoticeLabel.layer.cornerRadius = 6.0
        bountyNoticeLabel.clipsToBounds = true
        
        displayQuestion()
    }
    
    @objc private func contextMenuTapped() {
        contextMenu.presentActions([!(question.isUpvotedByCurrentUser ?? false) ? .upvote : .undoUpvote,
                                    !(question.isDownvotedByCurrentUser ?? false) ? .downvote : .undoDownvote,
                                    !(question.isFavoritedByCurrentUser ?? false) ? .favorite : .undoFavorite,
                                    .delete, .share])
    }
    
    func update(for question: Question) {
        self.question = question
        displayQuestion()
    }
    
    private func displayQuestion() {
        profileImageView.setUser(question.owner)
        userInfoLabel.setInfo(username: question.owner?.name, reputation: question.owner?.reputation, type: question.owner?.type)
        postedDateLabel.text = question.creationDate!.getCreationTimeText()
        scoreLabel.text = (question.score ?? 0).toString()
        scoreLabel.isAccepted = false
        favoritedCountLabel.text = (question.favoritesCount ?? 0).toString()
        favoriteIconImageView.image = UIImage(named: (question.isFavoritedByCurrentUser ?? false) ? "star_filled" : "star_empty")!.withRenderingMode(.alwaysTemplate)
        
        bodyWebView.loadHTML(string: "<h1>\(question.title!)</h1>" + question.bodyText!)
        
        commentsButton.setTitle("Show comments (\(question.commentsCount ?? 0))", for: .normal)
        
        if let editor = question.lastEditor, let editDate = question.lastEditDate {
            if editorView.superview == nil {
                parentSV.addArrangedSubview(editorView)
            }

            editedDateLabel.text = "Edited " + editDate.getCreationTimeText(shortForm: true)
            
            if editor.id! != (question.owner?.id ?? editor.id!) {
                editorProfileImageView.setUser(editor)
                editedDateLabel.font = UIFont.systemFont(ofSize: 12.0)
                editorUserInfoLabel.isHidden = false
                editorUserInfoLabel.setInfo(username: editor.name, reputation: editor.reputation, type: editor.type)
                editorProfileImageView.isHidden = false
            } else {
                editorUserInfoLabel.isHidden = true
                editedDateLabel.font = UIFont.systemFont(ofSize: 14.0)
                editorProfileImageView.isHidden = true
            }
        } else if editorView.superview != nil {
            parentSV.removeArrangedSubview(editorView)
            editorView.removeFromSuperview()
        }
        
        if let bountyAmount = question.bountyAmount, let bountyExprireDate = question.bountyClosesDate {
            bountyNoticeLabel.text = "Active bounty of +\(bountyAmount) expires " + bountyExprireDate.getExpiresTimeText()
            bountyNoticeHeightConstraint.constant = 20.0
            topConstraint.constant = 8.0
        } else {
            bountyNoticeHeightConstraint.constant = 0.0
            topConstraint.constant = 0.0
        }
        
        tagsCollectionView.tagNames = question.tags!
        navigationItem.titleView = QuestionStatusView(for: question)
    }
    
    @objc private func didTapCommentsButton(_ button: UIButton) {
        if centerConstraint.constant == 0.0 {
            button.setTitle(button.titleLabel!.text!.replacingOccurrences(of: "Show", with: "Hide"), for: .normal)
            centerConstraint.constant = -view.frame.height + 40
            spaceConstraint.constant = 8.0
        } else {
            centerConstraint.constant = 0.0
            spaceConstraint.constant = 0.0
            button.setTitle(button.titleLabel!.text!.replacingOccurrences(of: "Hide", with: "Show"), for: .normal)
        }
        
        UIView.animate(withDuration: 0.33, animations: {
            self.view.layoutIfNeeded()
        }, completion: { success in
            if success && self.centerConstraint.constant != 0 {
                self.commentsTableView.reloadData()
            }
        })
    }
}

extension QuestionPostViewController: UITableViewDelegate, UITableViewDataSource, CommentTableViewCellDelegate {
    func actionButtonTapped(at indexPath: IndexPath) {
        self.indexPath = indexPath
        contextMenu.presentActions([!(question.comments?[indexPath.row].isUpvotedByCurrentUser ?? false) ? .upvote : .undoUpvote, .delete])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentTableViewCell.self), for: indexPath) as! CommentTableViewCell
        cell.setup(for: question.comments![indexPath.row])
        cell.linkHandler = self
        cell.delegate = self
        cell.commentsTableView = tableView as? CommentsTableView
        return cell
    }
}

extension QuestionPostViewController: ContextMenuDelegate {
    func contextMenu(_ contextMenu: ContextMenu, didSelect action: ContextMenuAction) {
        if let indexPath = self.indexPath {
            switch action {
            case .upvote:
                ContextActions.performAction(.upvoteComment(id: question.comments![indexPath.row].id!), completion: { success in
                    if success, let cell = self.commentsTableView.cellForRow(at: indexPath) as? CommentTableViewCell {
                        self.question.comments![indexPath.row].score! += 1
                        self.question.comments![indexPath.row].isUpvotedByCurrentUser = true
                        cell.scoreLabel.text = String(self.question.comments![indexPath.row].score!)
                    }
                })
            case .undoUpvote:
                ContextActions.performAction(.undoCommentUpvote(id: question.comments![indexPath.row].id!), completion: { success in
                    if success, let cell = self.commentsTableView.cellForRow(at: indexPath) as? CommentTableViewCell {
                        self.question.comments![indexPath.row].score! -= 1
                        self.question.comments![indexPath.row].isUpvotedByCurrentUser = false
                        cell.scoreLabel.text = String(self.question.comments![indexPath.row].score!)
                    }
                })
            case .delete:
                ContextActions.performAction(.deleteComment(id: question.comments![indexPath.row].id!), completion: { success in
                    if success {
                        self.commentsTableView.beginUpdates()
                        self.question.comments?.remove(at: indexPath.row)
                        self.commentsTableView.deleteRows(at: [indexPath], with: .left)
                        self.commentsTableView.endUpdates()
                    }
                })
            default:
                fatalError()
            }
        } else {
            switch action {
            case .upvote:
                ContextActions.performAction(.upvoteQuestion(id: question.id!), completion: { success in
                    if success {
                        self.question.score! += 1
                        self.question.isUpvotedByCurrentUser = true
                        self.scoreLabel.text = self.question.score?.toString()
                    }
                })
                
            case .undoUpvote:
                ContextActions.performAction(.undoQuestionUpvote(id: question.id!), completion: { success in
                    if success {
                        self.question.score! -= 1
                        self.question.isUpvotedByCurrentUser = false
                        self.scoreLabel.text = self.question.score?.toString()
                    }
                })
                
            case .downvote:
                ContextActions.performAction(.downvoteQuestion(id: question.id!), completion: { success in
                    if success {
                        self.question.score! -= 1
                        self.question.isDownvotedByCurrentUser = true
                        self.scoreLabel.text = self.question.score?.toString()
                    }
                })
                
            case .undoDownvote:
                ContextActions.performAction(.undoQuestionDownvote(id: question.id!), completion: { success in
                    if success {
                        self.question.score! += 1
                        self.question.isDownvotedByCurrentUser = false
                        self.scoreLabel.text = self.question.score?.toString()
                    }
                })
                
            case .favorite:
                ContextActions.performAction(.favoriteQuestion(id: question.id!), completion: { success in
                    if success {
                        self.question.favoritesCount! += 1
                        self.question.isFavoritedByCurrentUser = true
                        self.favoritedCountLabel.text = self.question.favoritesCount!.toString()
                        self.favoriteIconImageView.image = UIImage(named: "star_filled")!.withRenderingMode(.alwaysTemplate)
                    }
                })
                
            case .undoFavorite:
                ContextActions.performAction(.undoQuestionFavorite(id: question.id!), completion: { success in
                    if success {
                        self.question.favoritesCount! -= 1
                        self.question.isFavoritedByCurrentUser = false
                        self.favoritedCountLabel.text = self.question.favoritesCount!.toString()
                        self.favoriteIconImageView.image = UIImage(named: "star_empty")!.withRenderingMode(.alwaysTemplate)
                    }
                })
                
            case .delete:
                ContextActions.performAction(.deleteQuestion(id: question.id!), completion: { success in
                    if success {
                        self.parent?.navigationController?.popViewController(animated: true)
                    }
                })
                
            case .share:
                ContextActions.showShareOptions(message: "Check out this question on Stack Overflow website",
                                                shareLink: self.question.shareLink!,
                                                in: self)
                
            default:
                fatalError("action unsupported")
            }
        }
    }
}
