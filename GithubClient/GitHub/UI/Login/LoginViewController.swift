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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signInButton.layer.cornerRadius = 20
    }
    @IBAction func signInTapped(_ sender: UIButton) {
        GitHubAuthService.shared.auth(viewController: self)
    }
}
