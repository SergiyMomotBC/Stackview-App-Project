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
        
        let frequentAction = CFAlertAction(title: "Frequent questions", style: .Default, alignment: .justified, backgroundColor: UIColor.secondaryAppColor, textColor: .white, handler: { _ in
            navigationController.show(TagFrequentQuestionsViewController(for: tag), sender: nil)
        })
        alert.addAction(frequentAction)
        
        let topUsersAction = CFAlertAction(title: "Top users", style: .Default, alignment: .justified, backgroundColor: UIColor.secondaryAppColor, textColor: .white, handler: nil)
        alert.addAction(topUsersAction)
        
        let moreInfoAction = CFAlertAction(title: "More info", style: .Default, alignment: .justified, backgroundColor: UIColor.secondaryAppColor, textColor: .white, handler: { _ in
            navigationController.show(TagWikiViewController(for: info.tagWiki!.bodyText!), sender: nil)
        })
        alert.addAction(moreInfoAction)
        
        let closeAction = CFAlertAction(title: "Close", style: .Default, alignment: .justified, backgroundColor: UIColor.flatRed, textColor: .white, handler: nil)
        alert.addAction(closeAction)
        
        navigationController.topViewController?.present(alert, animated: true, completion: nil)
    }
}
