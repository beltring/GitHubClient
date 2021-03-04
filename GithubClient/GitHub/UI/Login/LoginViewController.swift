//
//  LoginViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/22/21.
//

import UIKit
import OAuthSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    
    private let network = NetworkReachabilityManager.sharedInstance
    
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
    
    @IBAction func signInTapped(_ sender: UIButton) {
        GitHubAuthService.shared.auth(viewController: self)
    }
}
