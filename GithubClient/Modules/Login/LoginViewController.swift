//
//  LoginViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/22/21.
//

import OAuthSwift
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet private weak var signInButton: UIButton!
    
    private let network = NetworkReachabilityManager.sharedInstance
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        network.reachability.whenUnreachable = { _ in
            DispatchQueue.main.async {
                let vc = OfflineViewController.initial()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        signInButton.layer.cornerRadius = 20
    }
    
    // MARK: - Actions
    @IBAction private func signInTapped(_ sender: UIButton) {
        GitHubAuthService.shared.auth(viewController: self)
    }
}
