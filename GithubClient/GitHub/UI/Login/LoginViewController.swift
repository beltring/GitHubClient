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
    private let reachability = try! Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        }
        catch {
            print("could not start reachability notifier")
        }
        
        signInButton.layer.cornerRadius = 20
    }
    
    @IBAction func signInTapped(_ sender: UIButton) {
        GitHubAuthService.shared.auth(viewController: self)
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .unavailable:
            signInButton.isHidden = true
            presentAlert(title: "Error", message: "Network not reachable", preferredStyle: .alert, cancelStyle: .destructive)
        default:
            if signInButton.isHidden {
                signInButton.isHidden.toggle()
            }
        }
    }
}
