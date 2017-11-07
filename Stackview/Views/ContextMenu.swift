//
//  ContextMenu.swift
//  Stackview
//
//  Created by Sergiy Momot on 10/10/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

enum ContextMenuAction {
    case close
    case upvote
    case undoUpvote
    case downvote
    case undoDownvote
    case favorite
    case undoFavorite
    case accept
    case undoAccept
    case delete
    case share
}

fileprivate let actionsMap: [ContextMenuAction: ContextMenuItem] = [.upvote: ContextMenuItem(title: "Upvote", icon: UIImage(named: "upvote_icon")!),
                                                                    .undoUpvote: ContextMenuItem(title: "Undo upvote", icon: UIImage(named: "upvote_icon")!),
                                                                    .downvote: ContextMenuItem(title: "Downvote", icon: UIImage(named: "downvote_icon")!),
                                                                    .undoDownvote: ContextMenuItem(title: "Undo downvote", icon: UIImage(named: "downvote_icon")!),
                                                                    .favorite: ContextMenuItem(title: "Favorite", icon: UIImage(named: "favorite_icon")!),
                                                                    .undoFavorite: ContextMenuItem(title: "Undo favorite", icon: UIImage(named: "favorite_icon")!),
                                                                    .accept: ContextMenuItem(title: "Accept", icon: UIImage(named: "accept_icon")!),
                                                                    .undoAccept: ContextMenuItem(title: "Undo accept", icon: UIImage(named: "accept_icon")!),
                                                                    .delete: ContextMenuItem(title: "Delete", icon: UIImage(named: "delete_icon")!),
                                                                    .share: ContextMenuItem(title: "Share", icon: UIImage(named: "share_icon")!),
                                                                    .close: ContextMenuItem(title: "Close", icon: UIImage(named: "close_icon")!)]

struct ContextMenuItem {
    let title: String
    let icon: UIImage
}

class ContextMenu: UIVisualEffectView {
    fileprivate let animationDuration = 0.25
    fileprivate var actions: [ContextMenuAction] = []
    fileprivate var tableViewHeightConstraint: NSLayoutConstraint!
    
    weak var selectionDelegate: ContextMenuDelegate?
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.allowsMultipleSelection = false
        table.alwaysBounceVertical = false
        table.estimatedRowHeight = 0.0
        table.rowHeight = 64.0
        table.separatorStyle = .none
        table.register(UINib(nibName: String(describing: ContextMenuCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ContextMenuCell.self))
        return table
    }()
    
    init(in view: UIView) {
        super.init(effect: UIBlurEffect(style: .dark))
        frame = UIScreen.main.bounds
        view.addSubview(self)
        
        contentView.addSubview(tableView)
        tableView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        tableView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -60.0).isActive = true
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0.0)
        tableViewHeightConstraint.isActive = true
        
        alpha = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: animationDuration, animations: {
            self.alpha = 0.0
        })
    }
    
    func presentActions(_ actions: [ContextMenuAction]) {
        self.actions = actions + [.close]
        tableView.reloadData()
        tableViewHeightConstraint.constant = CGFloat(self.actions.count) * tableView.rowHeight
        
        UIView.animate(withDuration: animationDuration) {
            self.alpha = 1.0
        }
    }
}

extension ContextMenu: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContextMenuCell.self), for: indexPath) as! ContextMenuCell
        cell.setup(for: actionsMap[actions[indexPath.row]]!)
        cell.contentView.subviews.first?.backgroundColor = indexPath.row < actions.count - 1 ? .flatPurple : .flatRed
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.alpha = 0.0
        }) { success in
            if success && indexPath.row < self.actions.count - 1 {
                self.selectionDelegate?.contextMenu(self, didSelect: self.actions[indexPath.row])
            }
        }
    }
}
