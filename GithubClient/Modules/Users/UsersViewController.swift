//
//  UsersViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 3/1/21.
//

import Kingfisher
import PopupDialog
import SafariServices
import UIKit

class UsersViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private let searchService = SearchApiService()
    private var users = [User]()
    private var searchText = ""
    private var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Users"
        setupTableView()
        setupActivityIndicator()
        activityIndicatorView.startAnimating()
        fetchUsers(searchText: searchText)
    }

    // MARK: - Setup
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        UserTableViewCell.registerCellNib(in: tableView)
    }
    
    private func setupActivityIndicator() {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        tableView.backgroundView = activityIndicatorView
        self.activityIndicatorView = activityIndicatorView
    }
    
    private func setupPopup(user: User) -> PopupDialog {
        let avatarUrl = URL(string: user.avatarUrl!)
        let url = URL(string: user.url!)
        
        let dialogAppearance = PopupDialogDefaultView.appearance()
        dialogAppearance.titleFont = .boldSystemFont(ofSize: 34)
        CancelButton.appearance().titleColor = .black
        CancelButton.appearance().titleFont = .systemFont(ofSize: 18)
        DefaultButton.appearance().titleFont = .boldSystemFont(ofSize: 18)
        
        let title = user.login
        let imageView = UIImageView()
        imageView.kf.setImage(with: avatarUrl)
        let popup = PopupDialog(title: title, message: "", image: imageView.image)

        let cancelButton = CancelButton(title: "Cancel") {}
        let detailButton = DefaultButton(title: "Detail", height: 60) { [weak self] in
            self?.presentSafariViewController(url: url)
        }
        
        popup.addButtons([detailButton, cancelButton])

        return popup
    }
    
    // MARK: - API calls
    private func fetchUsers(searchText: String) {
        searchService.getUsersBySearchText(searchText: searchText) { [weak self] result in
    
            switch result {
            case .success(let userData):
                self?.users = userData.users ?? [User]()
                self?.tableView.reloadData()
            case .failure(let error):
                self?.presentAlert(message: error.localizedDescription)
            }
            
            self?.activityIndicatorView.stopAnimating()
        }
    }
    
    // MARK: - Get/Set methods
    func setSearchText(searchText: String) {
        self.searchText = searchText
    }
}

// MARK: - UITableViewDataSource
extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UserTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        
        let user = users[indexPath.row]
        
        cell.configure(user: user)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        let popup = setupPopup(user: user)
        self.present(popup, animated: true, completion: nil)
    }
}