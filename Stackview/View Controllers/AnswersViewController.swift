//
//  AnswersViewController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/20/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class AnswersViewController: UIViewController, LinkHandler, SelectedCodeHandler, SelectedImageHandler {
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(UINib(nibName: String(describing: AnswerCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: AnswerCollectionViewCell.self))
        return view
    }()
    
    lazy var positionLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100.0, height: 30))
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textAlignment = .center
        return label
    }()

    lazy var contextMenu = ContextMenu(in: self.navigationController!.view)
    var answers: [Answer]
    var centerYConstraint: NSLayoutConstraint!
    var commentsTableView: CommentsTableView!
    var spaceConstraint: NSLayoutConstraint!
    var currentAnswerIndex = 0
    var initialAnswerID: Int?
    var indexPath: IndexPath?
    var doneWithLayout = false
    
    init(for answers: [Answer], answerID: Int? = nil) {
        self.initialAnswerID = answerID
        self.answers = answers.sorted(by: { $0.score! > $1.score! })
        if let acceptedIndex = self.answers.index(where: { $0.isAccepted ?? false }) {
            let acceptedAnswer = self.answers.remove(at: acceptedIndex)
            self.answers.insert(acceptedAnswer, at: 0)
        }
        
        super.init(nibName: nil, bundle: nil)
    }

    func scrollToAnswer(id: Int, animated: Bool = false) {
        if let index = answers.index(where: { $0.id! == id }) {
            collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: animated)
            currentAnswerIndex = index
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(for answers: [Answer]) {
        self.answers = answers.sorted(by: { $0.score! > $1.score! })
        if let acceptedIndex = self.answers.index(where: { $0.isAccepted ?? false }) {
            let acceptedAnswer = self.answers.remove(at: acceptedIndex)
            self.answers.insert(acceptedAnswer, at: 0)
        }
        
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainAppColor
        
        contextMenu.selectionDelegate = self
        
        collectionView.emptyDataSetSource = self
        view.addSubview(collectionView)
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYConstraint = collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        centerYConstraint.isActive = true
        
        commentsTableView = CommentsTableView()
        commentsTableView.tag = 1
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        view.addSubview(commentsTableView)
        if #available(iOS 11.0, *) {
            commentsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            commentsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            commentsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            commentsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            commentsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            commentsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        
        spaceConstraint = commentsTableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor)
        spaceConstraint.priority = .defaultHigh
        spaceConstraint.isActive = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more_icon")!.withRenderingMode(.alwaysTemplate),
                                                            style: .plain, target: self, action: #selector(contextMenuTapped))
        navigationItem.titleView = positionLabel
        positionLabel.text = !answers.isEmpty ? "1 of \(answers.count)" : "No answers"
        
        collectionView.performBatchUpdates({
            self.collectionView.reloadData()
        }) { success in
            if let answerIDToScroll = self.initialAnswerID {
                self.scrollToAnswer(id: answerIDToScroll)
            }
        }
    }
    
    @objc private func contextMenuTapped() {
        guard !answers.isEmpty else { return }
        
        contextMenu.presentActions([!(answers[currentAnswerIndex].isUpvotedByCurrentUser ?? false) ? .upvote : .undoUpvote,
                                    !(answers[currentAnswerIndex].isDownvotedByCurrentUser ?? false) ? .downvote : .undoDownvote,
                                    !(answers[currentAnswerIndex].isAcceptedByCurrentUser ?? false) ? .accept : .undoAccept, .delete, .share])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard !doneWithLayout else { return }
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = view.frame.size
        }
        
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.0).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        
        doneWithLayout = true
    }
}

extension AnswersViewController: Tabbable {
    var icon: UIImage {
        return UIImage(named: "answers_icon")!.withRenderingMode(.alwaysTemplate)
    }
    
    var iconTitle: String {
        return "Answers"
    }
}

extension AnswersViewController: AnswersCollectionViewCellDelegate {
    func commentsButtonWasTapped(_ button: UIButton) {
        if centerYConstraint.constant == 0.0 {
            commentsTableView.reloadData()
            collectionView.isScrollEnabled = false
            spaceConstraint.constant = 8.0
            button.setTitle(button.titleLabel!.text!.replacingOccurrences(of: "Show", with: "Hide"), for: .normal)
            centerYConstraint.constant = -collectionView.frame.height + 40
        } else {
            centerYConstraint.constant = 0.0
            spaceConstraint.constant = 0.0
            button.setTitle(button.titleLabel!.text!.replacingOccurrences(of: "Hide", with: "Show"), for: .normal)
            collectionView.isScrollEnabled = true
        }
        
        UIView.animate(withDuration: 0.33) {
            self.view.layoutIfNeeded()
        }
    }
}

extension AnswersViewController: UITableViewDelegate, UITableViewDataSource, CommentTableViewCellDelegate {
    func actionButtonTapped(at indexPath: IndexPath) {
        self.indexPath = indexPath
        contextMenu.presentActions([!(answers[currentAnswerIndex].comments?[indexPath.row].isUpvotedByCurrentUser ?? false) ? .upvote : .undoUpvote, .delete])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return answers.isEmpty ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers[currentAnswerIndex].comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentTableViewCell.self), for: indexPath) as! CommentTableViewCell
        cell.setup(for: answers[currentAnswerIndex].comments![indexPath.row])
        cell.linkHandler = self
        cell.delegate = self
        cell.commentsTableView = tableView as? CommentsTableView
        return cell
    }
}

extension AnswersViewController: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "no_answers_empty_state")!
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18.0)]
        return NSAttributedString(string: "There are no answers so far.", attributes: attributes)
    }
}

extension AnswersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answers.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.tag == 0 else { return }
        
        let offset = scrollView.contentOffset.x / scrollView.frame.width
        
        if abs(offset - floor(offset)) <= 0.01 {
            let pageNumber = Int(offset) + 1
            currentAnswerIndex = Int(offset)
            positionLabel.text = "\(pageNumber) of \(answers.count)"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AnswerCollectionViewCell.self), for: indexPath) as! AnswerCollectionViewCell
        cell.setup(for: answers[indexPath.row])
        cell.delegate = self
        cell.bodyWebView.linkHandler = self
        cell.bodyWebView.selectedCodeHandler = self
        cell.bodyWebView.selectedImageHandler = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension AnswersViewController: ContextMenuDelegate {
    func contextMenu(_ contextMenu: ContextMenu, didSelect action: ContextMenuAction) {
        if let indexPath = self.indexPath {
            switch action {
            case .upvote:
                ContextActions.performAction(.upvoteComment(id: answers[currentAnswerIndex].comments![indexPath.row].id!), completion: { success in
                    if success, let cell = self.commentsTableView.cellForRow(at: indexPath) as? CommentTableViewCell {
                        self.answers[self.currentAnswerIndex].comments![indexPath.row].score! += 1
                        self.answers[self.currentAnswerIndex].comments![indexPath.row].isUpvotedByCurrentUser = true
                        cell.scoreLabel.text = String(self.answers[self.currentAnswerIndex].comments![indexPath.row].score!)
                    }
                })
            case .undoUpvote:
                ContextActions.performAction(.undoCommentUpvote(id: answers[currentAnswerIndex].comments![indexPath.row].id!), completion: { success in
                    if success, let cell = self.commentsTableView.cellForRow(at: indexPath) as? CommentTableViewCell {
                        self.answers[self.currentAnswerIndex].comments![indexPath.row].score! -= 1
                        self.answers[self.currentAnswerIndex].comments![indexPath.row].isUpvotedByCurrentUser = false
                        cell.scoreLabel.text = String(self.answers[self.currentAnswerIndex].comments![indexPath.row].score!)
                    }
                })
            case .delete:
                ContextActions.performAction(.deleteComment(id: answers[currentAnswerIndex].comments![indexPath.row].id!), completion: { success in
                    if success {
                        self.commentsTableView.beginUpdates()
                        self.answers[self.currentAnswerIndex].comments?.remove(at: indexPath.row)
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
                ContextActions.performAction(.upvoteAnswer(id: answers[currentAnswerIndex].id!), completion: { success in
                    if success, let cell = self.collectionView.visibleCells.first as? AnswerCollectionViewCell {
                        self.answers[self.currentAnswerIndex].score! += 1
                        self.answers[self.currentAnswerIndex].isUpvotedByCurrentUser = true
                        cell.scoreLabel.text = self.answers[self.currentAnswerIndex].score?.toString()
                    }
                })
                
            case .undoUpvote:
                ContextActions.performAction(.undoAnswerUpvote(id: answers[currentAnswerIndex].id!), completion: { success in
                    if success, let cell = self.collectionView.visibleCells.first as? AnswerCollectionViewCell {
                        self.answers[self.currentAnswerIndex].score! -= 1
                        self.answers[self.currentAnswerIndex].isUpvotedByCurrentUser = false
                        cell.scoreLabel.text = self.answers[self.currentAnswerIndex].score?.toString()
                    }
                })
                
            case .downvote:
                ContextActions.performAction(.downvoteAnswer(id: answers[currentAnswerIndex].id!), completion: { success in
                    if success, let cell = self.collectionView.visibleCells.first as? AnswerCollectionViewCell {
                        self.answers[self.currentAnswerIndex].score! -= 1
                        self.answers[self.currentAnswerIndex].isDownvotedByCurrentUser = true
                        cell.scoreLabel.text = self.answers[self.currentAnswerIndex].score?.toString()
                    }
                })
                
            case .undoDownvote:
                ContextActions.performAction(.undoAnswerDownvote(id: answers[currentAnswerIndex].id!), completion: { success in
                    if success, let cell = self.collectionView.visibleCells.first as? AnswerCollectionViewCell {
                        self.answers[self.currentAnswerIndex].score! += 1
                        self.answers[self.currentAnswerIndex].isDownvotedByCurrentUser = false
                        cell.scoreLabel.text = self.answers[self.currentAnswerIndex].score?.toString()
                    }
                })
                
            case .accept:
                ContextActions.performAction(.acceptAnswer(id: answers[currentAnswerIndex].id!), completion: { success in
                    if success, let cell = self.collectionView.visibleCells.first as? AnswerCollectionViewCell {
                        self.answers[self.currentAnswerIndex].isAccepted = true
                        self.answers[self.currentAnswerIndex].isAcceptedByCurrentUser = true
                        cell.scoreLabel.isAccepted = true
                        cell.contentView.subviews.first?.layer.borderColor = UIColor.greenAcceptedColor.cgColor
                    }
                })
                
            case .undoAccept:
                ContextActions.performAction(.undoAnswerAccept(id: answers[currentAnswerIndex].id!), completion: { success in
                    if success, let cell = self.collectionView.visibleCells.first as? AnswerCollectionViewCell {
                        self.answers[self.currentAnswerIndex].isAccepted = false
                        self.answers[self.currentAnswerIndex].isAcceptedByCurrentUser = false
                        cell.scoreLabel.isAccepted = false
                        cell.contentView.subviews.first?.layer.borderColor = UIColor.clear.cgColor
                    }
                })
                
            case .delete:
                ContextActions.performAction(.deleteAnswer(id: answers[currentAnswerIndex].id!), completion: { success in
                    if success {
                        self.answers.remove(at: self.currentAnswerIndex)
                        self.collectionView.deleteItems(at: [IndexPath(item: self.currentAnswerIndex, section: 0)])
                        if !self.answers.isEmpty {
                            self.positionLabel.text = "\(self.currentAnswerIndex < self.answers.count ? self.currentAnswerIndex + 1 : self.answers.count) of \(self.answers.count)"
                        } else {
                            self.positionLabel.text = "No answers"
                        }
                    }
                })
                
            case .share:
                ContextActions.showShareOptions(message: "Check out this answer on Stack Overflow website",
                                                shareLink: self.answers[self.currentAnswerIndex].shareLink!,
                                                in: self)
                
            default:
                fatalError("action unsupported")
            }
        }
    }
}
