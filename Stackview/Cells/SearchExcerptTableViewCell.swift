//
//  SearchExcerptTableViewCell.swift
//  Stackview
//
//  Created by Sergiy Momot on 8/28/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import UIKit

class SearchExcerptTableViewCell: GenericCell<SearchExcerpt> {
    @IBOutlet weak var postTypeLabel: UILabel!
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var answersScoreLabel: ScoreLabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var excerptLabel: UILabel!
    @IBOutlet weak var tagsCollectionView: TagsCollectionView!

    override func setup(for searchExcerpt: SearchExcerpt) {
        guard let type = searchExcerpt.itemType else { return }
        
        postTypeLabel.text = type == .question ? "Question" : "Answer"
        
        if let creationDate = searchExcerpt.creationDate {
            createdTimeLabel.text = creationDate.getCreationTimeText()
        } else {
            createdTimeLabel.text = ""
        }
        
        answersScoreLabel.backgroundColor = (searchExcerpt.hasAcceptedAnswer ?? false) ? .greenAcceptedColor : .clear
        
        if type == .question {
            let aCount = searchExcerpt.answersCount ?? 0
            answersScoreLabel.emphasize(text: "\(aCount.toString()) \(abs(aCount) == 1 ? "answer" : "answers")")
            answersScoreLabel.isAccepted = searchExcerpt.hasAcceptedAnswer ?? false
        } else {
            let score = searchExcerpt.score ?? 0
            answersScoreLabel.emphasize(text: "\(score.toString()) \(abs(score) == 1 ? "vote" : "votes")")
            answersScoreLabel.isAccepted = searchExcerpt.isAccepted ?? false
        }
        
        if searchExcerpt.hasAcceptedAnswer ?? false {
            let answers = NSMutableAttributedString(attributedString: answersScoreLabel.attributedText!)
            answers.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: answers.length))
            answersScoreLabel.attributedText = answers
        }
        
        titleLabel.text = searchExcerpt.title?.htmlUnescape()
        excerptLabel.attributedText = highlight(excerpt: prettify(excerpt: searchExcerpt.excerptText ?? ""))
        
        DispatchQueue.main.async {
            self.tagsCollectionView.tagNames = searchExcerpt.tags ?? []
        }
    }
    
    private func prettify(excerpt: String) -> String {
        return excerpt.htmlUnescape()
            .replacingOccurrences(of: "(\n)+", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "( )+", with: " ", options: .regularExpression)
            .replacingOccurrences(of: " \u{2026}", with: "...")
    }

    private func highlight(excerpt: String) -> NSAttributedString {
        let open = "<span class=\"highlight\">"
        let close = "</span>"
        
        var highlightRanges: [Range<String.Index>] = []
        var text = excerpt
        
        while let openRange = text.range(of: open), let closeRange = text.range(of: close) {
            let upperBound = text.index(openRange.lowerBound, offsetBy: text.distance(from: openRange.upperBound, to: closeRange.lowerBound))
            let range = openRange.lowerBound..<upperBound
            highlightRanges.append(range)
            text.removeSubrange(openRange)
            text.removeSubrange(range.upperBound..<text.index(range.upperBound, offsetBy: close.count))
        }
        
        let string = NSMutableAttributedString(string: text)
        
        for range in highlightRanges {
            string.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14.0), range: NSRange(range, in: excerpt))
        }
        
        return string
        
    }
}

