//
//  ProfileViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/22/21.
//

import UIKit
import SafariServices
import KeychainSwift

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .done, target: self, action: #selector(signOutTapped))
    }
}

// MARK: - SFSafariViewControllerDelegate
extension ProfileViewController: SFSafariViewControllerDelegate {
    
    @IBAction func signOutTapped(){
        let urlString = "https://github.com/logout"
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            // TODO: add processing for clicking the done button
            present(vc, animated: true, completion: { [weak self] in
                KeychainSwift().clear()
                let nav = self?.navigationController as! RootNavigationViewController
                nav.setRootController()
            })
        }
    }
}
