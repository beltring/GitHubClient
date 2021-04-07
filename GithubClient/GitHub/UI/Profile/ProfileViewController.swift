//
//  ProfileViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/22/21.
//

import KeychainSwift
import Kingfisher
import SafariServices
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var locationStackView: UIStackView!
    @IBOutlet weak var mailStackView: UIStackView!
    
    private let userService = UserApiService()
    private var user: User?
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .done, target: self, action: #selector(signOutTapped))
        
        setupActivityIndicator()
        activityIndicator.startAnimating()
        profileImage.layer.cornerRadius = 35
        fetchUserInformation()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

// MARK: - Fetch data
extension ProfileViewController {
    
    private func fetchUserInformation() {
        userService.getUserInformation { [weak self] result in
            self?.activityIndicator.stopAnimating()
            
            switch result {
            case .success(let user):
                self?.success(user: user)
            case .failure(let error):
                self?.presentAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func success(user: User) {
        self.user = user
        self.nameLabel.text = user.name
        self.userNameLabel.text = user.login
        self.followersCountLabel.text = String(user.followers ?? 0)
        self.followingCountLabel.text = String(user.following ?? 0)
        
        if let location = user.location {
            self.locationLabel.text = location
        }
        else {
            locationStackView.isHidden.toggle()
        }
        
        if let email = user.email {
            self.mailLabel.text = email
        }
        else {
            mailStackView.isHidden.toggle()
        }
        
        guard let url = URL(string: user.avatarUrl!) else { return }
        profileImage.kf.setImage(with: url)
    }
}

// MARK: - SFSafariViewControllerDelegate
extension ProfileViewController: SFSafariViewControllerDelegate {
    
    @IBAction func signOutTapped() {
        if let url = URL(string: "https://github.com/logout") {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            // TODO: add processing for clicking the done button
            present(vc, animated: true, completion: { [weak self] in
                AuthorizeData.shared.resetData()
                let nav = self?.navigationController as! RootNavigationViewController
                nav.setRootController()
            })
        }
    }
}
