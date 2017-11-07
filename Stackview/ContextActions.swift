//
//  ContextActions.swift
//  Stackview
//
//  Created by Sergiy Momot on 10/10/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import CFAlertViewController

class ContextActions {
    static func performAction(_ action: StackExchangeAction, completion: @escaping (Bool) -> Void) {
        if AuthenticatedUser.current.accessToken != nil {
            let api = StackExchangeRequest()
            api.makeRequest(to: action.endpoint, method: .post, ignoreResult: true) { (data: [Decodable]?, error: RequestError?, _) in
                if let error = error {
                    switch error {
                    case .apiRequestError(let apiError):
                        self.showErrorPopup(title: "Action could not be completed.", message: apiError.message)
                        completion(false)
                    default:
                        self.showErrorPopup(title: "Error", message: "Request could not be completed. Either you are not connected to the Internet or the server is not responding.")
                        completion(false)
                    }
                } else {
                    completion(true)
                }
            }
        } else {
            showNeedsAuthenticationPopup()
        }
    }
    
    static func showShareOptions(message: String, shareLink: URL, in vc: UIViewController) {
        let activityViewController = UIActivityViewController(activityItems: [message, shareLink], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.airDrop, .assignToContact, .openInIBooks, .postToFlickr, .postToVimeo, .saveToCameraRoll, .print]
        vc.present(activityViewController, animated: true, completion: nil)
    }
    
    private static func showErrorPopup(title: String, message: String) {
        let alert = CFAlertViewController(title: title, titleColor: .mainAppColor, message: message, messageColor: .flatBlack,
                                          textAlignment: .left, preferredStyle: .alert, headerView: nil, footerView: nil, didDismissAlertHandler: nil)
        alert.addAction(CFAlertAction(title: "OK", style: .Default, alignment: .justified, backgroundColor: .flatRed, textColor: .white, handler: nil))
        MainViewController.topViewController?.present(alert, animated: true, completion: nil)
    }
    
    private static func showNeedsAuthenticationPopup() {
        let alert = CFAlertViewController(title: "Authentication required.", titleColor: .mainAppColor, message: "Only authorized Stack Overflow users can perform this action.",
                                          messageColor: .flatBlack, textAlignment: .left, preferredStyle: .alert,
                                          headerView: nil, footerView: nil, didDismissAlertHandler: nil)
        
        let authAction = CFAlertAction(title: "Authenticate", style: .Default, alignment: .justified, backgroundColor: .flatPurple, textColor: .white) { _ in
            AuthenticatedUser.current.authenticate()
        }
        
        let closeAction = CFAlertAction(title: "Cancel", style: .Default, alignment: .justified, backgroundColor: .flatRed, textColor: .white, handler: nil)
        
        alert.addAction(closeAction)
        alert.addAction(authAction)
        
        MainViewController.topViewController?.present(alert, animated: true, completion: nil)
    }
}
