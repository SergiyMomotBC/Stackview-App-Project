//
//  Authenticator.swift
//  Stackview
//
//  Created by Sergiy Momot on 10/6/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

import OAuthSwift
import NotificationCenter
import CFAlertViewController
import KeychainSwift

class AuthenticatedUser {
    static let userAuthenticatedNotificationName = "userAuthorized"
    
    static let current = AuthenticatedUser()
    
    private let callbackURL = URL(string: "smomot.stackview://se.auth-callback")!
    private let authorizeEndpoint = "https://stackexchange.com/oauth/dialog"
    private let requiredScopes = "read_inbox,write_access,private_info,no_expiry"
    private let clientID = "10576"
    private let accessTokenKeyName = "accessToken"
    private let api = StackExchangeRequest()
    private let userInfoArchiveURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!.appendingPathComponent("authenticatedUser")
    private let keychain = KeychainSwift()
    
    private lazy var authenticator = OAuth2Swift(consumerKey: clientID,
                                                 consumerSecret: "",
                                                 authorizeUrl: authorizeEndpoint,
                                                 responseType: "token")
    
    private(set) var accessToken: String? {
        didSet {
            if let token = accessToken {
                keychain.set(token, forKey: accessTokenKeyName)
            } else {
                keychain.delete(accessTokenKeyName)
            }
        }
    }
    
    var userInfo: User? {
        didSet {
            if let user = userInfo {
                if let data = try? JSONEncoder().encode(user) {
                    try? data.write(to: userInfoArchiveURL, options: .atomicWrite)
                }
            } else {
                try? FileManager.default.removeItem(at: userInfoArchiveURL)
            }
        }
    }
    
    init() {
        if let user = try? JSONDecoder().decode(User.self, from: Data(contentsOf: userInfoArchiveURL)) {
            userInfo = user
            accessToken = keychain.get(accessTokenKeyName)
        }
    }
    
    func authenticate() {
        guard accessToken == nil else { return }
        
        authenticator.authorizeURLHandler = SafariURLHandler(viewController: MainViewController.topViewController!, oauthSwift: authenticator)
        
        authenticator.authorize(withCallbackURL: callbackURL, scope: requiredScopes, state: "", success: { (credential, response, parameters) in
            self.accessToken = credential.oauthToken
            self.api.makeRequest(to: "me", completion: { (results: [User]?, _, _) in
                if let user = results?.first {
                    self.userInfo = user
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: AuthenticatedUser.userAuthenticatedNotificationName), object: nil)
                } else {
                    self.accessToken = nil
                    self.errorPopup(message: "User info could not be retrieved.")
                }
            })
            
        }, failure: { _ in
            self.errorPopup(message: "Authorization failed.")
        })
    }
    
    func deauthenticate() {
        guard let token = accessToken else { return }
        
        api.makeRequest(to: "access-tokens/\(token.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)/invalidate", noSite: true) { (result: [AccessToken]?, error: RequestError?, _) in
            if error != nil {
                self.errorPopup(message: "Deauthentication failed.")
            } else {
                self.userInfo = nil
                self.accessToken = nil
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: AuthenticatedUser.userAuthenticatedNotificationName), object: nil)
            }
        }
    }
    
    private func errorPopup(message: String) {
        let alert = CFAlertViewController(title: message, titleColor: .mainAppColor, message: nil, messageColor: nil,
                                          textAlignment: .left, preferredStyle: .alert, headerView: nil, footerView: nil, didDismissAlertHandler: nil)
        alert.addAction(CFAlertAction(title: "Close", style: .Default, alignment: .justified, backgroundColor: .flatRed, textColor: .white, handler: nil))
        MainViewController.topViewController?.present(alert, animated: true, completion: nil)
    }
    
    deinit {
        if let user = userInfo, let data = try? JSONEncoder().encode(user) {
            try? data.write(to: userInfoArchiveURL, options: .atomicWrite)
        }
    }
}

