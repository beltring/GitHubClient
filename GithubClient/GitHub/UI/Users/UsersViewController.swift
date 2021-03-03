//
//  UsersViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 3/1/21.
//

import UIKit
import SafariServices

class UsersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let searchService = SearchApiService()
    private var users = [User]()
    private var searchText = ""
    private weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Users"
        setupTableView()
        setupActivityIndicator()
        activityIndicatorView.startAnimating()
        fetchUsers(searchText: searchText)
    }

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
}

// MARK: - Get/Set methods
extension UsersViewController {
    func setSearchText(searchText: String) {
        self.searchText = searchText
    }
}

// MARK: - UITableViewDelegate&UITableViewDataSource
extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UserTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        
        let user = users[indexPath.row]
        
        cell.configure(user: user)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        guard let url = URL(string: user.url ?? "") else { return }
        presentSafariViewController(url: url)
    }
}

// MARK: - Fetch users
extension UsersViewController {
    func fetchUsers(searchText: String) {
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
}
