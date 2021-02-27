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
        self.locationLabel.text = user.location
        self.mailLabel.text = user.email
        self.followersCountLabel.text = String(user.followers ?? 0)
        self.followingCountLabel.text = String(user.following ?? 0)
        self.getImage(url: user.avatarUrl)
    }
    
    private func getImage(url: String?) {
        guard let url = URL(string: url ?? "") else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            if let error = error {
                self?.presentAlert(message: error.localizedDescription)
            }
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self?.profileImage.image = image
                }
            }
        }.resume()
    }
}

// MARK: - SFSafariViewControllerDelegate
extension ProfileViewController: SFSafariViewControllerDelegate {
    
    @IBAction func signOutTapped() {
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
