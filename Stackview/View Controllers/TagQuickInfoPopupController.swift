//
//  TagQuickInfoPopupController.swift
//  Stackview
//
//  Created by Sergiy Momot on 9/7/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import CFAlertViewController

class TagQuickInfoPopupController {
    static func displayQuickInfo(about tag: String) {
        guard let navigationController = (UIApplication.shared.keyWindow?.rootViewController as? MainViewController)?.currentContentViewController as? UINavigationController else {
            return
        }
        
        let alert = CFAlertViewController(title: nil, message: nil, textAlignment: .natural, preferredStyle: .alert, didDismissAlertHandler: nil)
        
        let info = TagQuickInfoViewController(for: tag)
        alert.addChildViewController(info)
        alert.headerView = info.view
        info.didMove(toParentViewController: alert)
        info.loadingView?.tintColor = UIColor.mainAppColor
        
        info.loadFinished = {
            let moreInfoAction = CFAlertAction(title: "More info", style: .Default, alignment: .justified, backgroundColor: UIColor.flatPurple, textColor: .white, handler: { _ in
                navigationController.show(TagWikiViewController(for: info.tagWiki!.bodyText!, tagName: info.tagWiki!.tagName!), sender: nil)
            })
            alert.addAction(moreInfoAction)
            
            let topUsersAction = CFAlertAction(title: "Top users", style: .Default, alignment: .justified, backgroundColor: UIColor.flatPurple, textColor: .white, handler: { _ in
                let tuvc = TabBarController(with: [TopTagUsersViewController(tagName: tag, forAskers: true), TopTagUsersViewController(tagName: tag, forAskers: false)])
                navigationController.show(tuvc, sender: nil)
            })
            alert.addAction(topUsersAction)
            
            let relativeTagsAction = CFAlertAction(title: "Related tags", style: .Default, alignment: .justified, backgroundColor: UIColor.flatPurple, textColor: .white, handler: { _ in
                navigationController.show(RelatedTagsViewController(for: tag), sender: nil)
            })
            alert.addAction(relativeTagsAction)
            
            let frequentAction = CFAlertAction(title: "Frequent questions", style: .Default, alignment: .justified, backgroundColor: UIColor.flatPurple, textColor: .white, handler: { _ in
                navigationController.show(TagFrequentQuestionsViewController(for: tag), sender: nil)
            })
            alert.addAction(frequentAction)

            alert.updateUI(withAnimation: true)
        }
        
        let closeAction = CFAlertAction(title: "Close", style: .Default, alignment: .justified, backgroundColor: UIColor.flatRed, textColor: .white, handler: nil)
        alert.addAction(closeAction)
        
        navigationController.topViewController?.present(alert, animated: true, completion: nil)
    }
}
