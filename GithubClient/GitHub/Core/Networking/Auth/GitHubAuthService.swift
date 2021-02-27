//
//  GitHubAuthService.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/23/21.
//

import Foundation
import KeychainSwift
import OAuthSwift

final class GitHubAuthService {
    
    private var oauthswift: OAuthSwift?
    static let shared = GitHubAuthService()
    private let keychain = KeychainSwift()
    
    private init() {}
    
    func auth(viewController vc: UIViewController){
        let oauthswift = OAuth2Swift(
            consumerKey:    "e37c794a79b6a108b19a",
            consumerSecret: "cd42384506f3fa0472abbe3c2145c23505fa04e3",
            authorizeUrl:   "https://github.com/login/oauth/authorize",
            accessTokenUrl: "https://github.com/login/oauth/access_token",
            responseType:   "code"
        )
        self.oauthswift = oauthswift
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: vc, oauthSwift: oauthswift)
        let state = generateState(withLength: 20)
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "githubClient://oauth-callback")!, scope: "delete_repo,read:user,repo,user:email", state: state) { [weak self] result in
            switch result {
            case .success(let (credential, _, _)):
                self?.keychain.set(credential.oauthToken, forKey: "accessToken")
                let rootVC = RootTabBarViewController.initial()
                vc.navigationController?.setViewControllers([rootVC], animated: true)
            case .failure(let error):
                print(error.description)
            }
        }
    }
}
