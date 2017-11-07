//
//  LinkHandler.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/27/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import Foundation

fileprivate let userLink = "stackoverflow.com/users/"
fileprivate let questionLink = "stackoverflow.com/questions/"
fileprivate let answerLink = "stackoverflow.com/a/"

protocol LinkHandler: class {
    func handleURL(_ url: URL)
}

extension LinkHandler where Self: UIViewController {
    func handleURL(_ url: URL) {
        guard !isImageFile(url: url) else { return }
        
        let s = url.absoluteString
        var destinationVC: UIViewController?
        
        if let range = s.range(of: userLink) {
            let endIndex = s.range(of: "/", options: [], range: range.upperBound..<s.endIndex)?.lowerBound ?? s.endIndex
            let userID = String(s[range.upperBound..<endIndex])
            destinationVC = UserProfileViewController(for: userID)
        } else if let range = s.range(of: questionLink) {
            let endIndex = s.range(of: "/", options: [], range: range.upperBound..<s.endIndex)?.lowerBound ?? s.endIndex
            let questionID = String(s[range.upperBound..<endIndex])
            destinationVC = QuestionDetailViewController(for: questionID, answerIDToPresentFirst: nil)
        } else if let range = s.range(of: answerLink) {
            let endIndex = s.range(of: "/", options: [], range: range.upperBound..<s.endIndex)?.lowerBound ?? s.endIndex
            let answerID = String(s[range.upperBound..<endIndex])
            destinationVC = QuestionDetailViewController(forAnswerID: answerID)
        }
        
        if let vc = destinationVC {
            navigationController?.show(vc, sender: nil)
        } else {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    private func isImageFile(url: URL) -> Bool {
        let supportedFormats = [".jpeg", ".jpg", ".png", ".gif", ".bmp"]

        let path = url.absoluteString.lowercased()
        for format in supportedFormats {
            if path.hasSuffix(format) {
                return true
            }
        }
        
        return false
    }
}
