
//
//  CommentTableViewCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/25/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

protocol CommentTableViewCellDelegate: class {
    func actionButtonTapped(at indexPath: IndexPath)
}

class CommentTableViewCell: GenericCell<Comment>, UITextViewDelegate {
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var userInfoLabel: UserInfoLabel!
    @IBOutlet weak var postedDateLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var replyToUserLabel: UILabel!
    @IBOutlet weak var contextMenuButton: UIButton!
    @IBOutlet weak var bountyNoticeLabel: PaddedLabel!
    
    let boldAttributes: [NSAttributedStringKey: Any] = [.font: UIFont(name: "HelveticaNeue-Bold", size: 14.0)!]
    let italicAttributes: [NSAttributedStringKey: Any] = [.font: UIFont(name: "HelveticaNeue-Italic", size: 14.0)!]
    let codeAttributes: [NSAttributedStringKey: Any] = [.backgroundColor: UIColor.codeBackgroundColor]
    let linkAttributes: [NSAttributedStringKey: Any] = [.foregroundColor: UIColor.linkColor]
    let boldItalicAttributes: [NSAttributedStringKey: Any] = [.font: UIFont(name: "HelveticaNeue-BoldItalic", size: 14.0)!]
    
    weak var linkHandler: LinkHandler?
    weak var delegate: CommentTableViewCellDelegate?
    weak var commentsTableView: CommentsTableView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentTextView.textContainerInset = .zero
        commentTextView.delegate = self
        scoreLabel.textColor = UIColor.greenAcceptedColor
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        contextMenuButton.imageView?.contentMode = .scaleAspectFit
        contextMenuButton.imageView?.tintColor = .flatRed
        contextMenuButton.setImage(UIImage(named: "more_icon")!.withRenderingMode(.alwaysTemplate), for: .normal)
        contextMenuButton.setImage(UIImage(named: "more_icon")!, for: .highlighted)
    }
    
    override func setup(for comment: Comment) {
        profileImageView.setUser(comment.owner)
        userInfoLabel.setInfo(username: comment.owner?.name, reputation: comment.owner?.reputation, type: comment.owner?.type)
        postedDateLabel.text = comment.creationDate!.getCreationTimeText()
        commentTextView.font = UIFont(name: "HelveticaNeue", size: 14.0)
        scoreLabel.text = String(comment.score ?? 0)

        if let bodyText = comment.bodyText, bodyText.hasPrefix("@") {
            let spaceIndex = bodyText.index(of: " ")!
            let username = String(bodyText[bodyText.index(after: bodyText.startIndex)..<spaceIndex])
            commentTextView.attributedText = parseCommentBody(String(bodyText.dropFirst(1 + bodyText.distance(from: bodyText.startIndex, to: spaceIndex))).htmlUnescape())
            replyToUserLabel.text = " To " + username + ":"
        } else {
            replyToUserLabel.text = ""
            commentTextView.attributedText = parseCommentBody(comment.bodyText?.htmlUnescape())
        }
    }
    
    @IBAction func actionButtonTapped() {
        if let tableView = self.commentsTableView, let indexPath = tableView.indexPath(for: self) {
            delegate?.actionButtonTapped(at: indexPath)
        }
    }
    
    private func parseCommentBody(_ text: String?) -> NSAttributedString {
        guard text != nil else {
            return NSAttributedString(string: "")
        }

        var html = text!
        
        var ranges: [(range: Range<String.Index>, attributes: [NSAttributedStringKey: Any])] = []
        
        var tags: [(closeTagName: String, attributeStartIndex: String.Index, styleAttributes: [NSAttributedStringKey: Any])] = []
        
        var index = html.startIndex
        while index != html.endIndex {
            if html[index] == "<" {
                if html[html.index(after: index)] == "/", let tag = tags.last {
                    html.removeSubrange(index...html.index(index, offsetBy: tag.closeTagName.count - 1))
                    ranges.append((range: tag.attributeStartIndex..<index, attributes: tag.styleAttributes))
                    tags.removeLast()
                } else {
                    if html[index...html.index(index, offsetBy: 5)] == "<b><i>" {
                        html.removeSubrange(index...html.index(index, offsetBy: 5))
                        tags.append((closeTagName: "</i></b>", attributeStartIndex: index, styleAttributes: boldItalicAttributes))
                    } else if html[index...html.index(index, offsetBy: 2)] == "<b>" {
                        html.removeSubrange(index...html.index(index, offsetBy: 2))
                        tags.append((closeTagName: "</b>", attributeStartIndex: index, styleAttributes: boldAttributes))
                    } else if html[index...html.index(index, offsetBy: 2)] == "<i>" {
                        html.removeSubrange(index...html.index(index, offsetBy: 2))
                        tags.append((closeTagName: "</i>", attributeStartIndex: index, styleAttributes: italicAttributes))
                    } else if html[index...html.index(index, offsetBy: 5)] == "<code>" {
                        html.removeSubrange(index...html.index(index, offsetBy: 5))
                        tags.append((closeTagName: "</code>", attributeStartIndex: index, styleAttributes: codeAttributes))
                    } else if html[index...html.index(index, offsetBy: 7)] == "<a href=" {
                        let closeIndex = nextIndex(of: ">", in: html, startingAt: index)!
                        let link = String(html[html.index(index, offsetBy: 9)..<nextIndex(of: "\"", in: html, startingAt: html.index(index, offsetBy: 9))!])
                        html.removeSubrange(index...closeIndex)
                        tags.append((closeTagName: "</a>", attributeStartIndex: index, styleAttributes: linkAttributes.merging([.link: link], uniquingKeysWith: { new, _ in new })))
                    } else {
                        index = html.index(after: index)
                    }
                }
            } else {
                index = html.index(after: index)
            }
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.25
        ranges.append((range: html.startIndex..<html.endIndex, attributes: [NSAttributedStringKey.paragraphStyle : paragraphStyle]))
        
        let attributedString = NSMutableAttributedString(string: html)
        
        for style in ranges {
            attributedString.addAttributes(style.attributes, range: NSRange(style.range, in: html))
        }
        
        return attributedString
    }
    
    private func nextIndex(of char: Character, in text: String, startingAt index: String.Index) -> String.Index? {
        var i = index
        while i != text.endIndex {
            if text[i] == char {
                return i
            } else {
                i = text.index(after: i)
            }
        }
        return nil
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        linkHandler?.handleURL(URL)
        return false
    }
}
