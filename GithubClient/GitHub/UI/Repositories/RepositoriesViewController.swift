//
//  RepositoriesViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/23/21.
//

import UIKit

class RepositoriesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let repositoryService = RepositoriesApiService()
    private var repositories = [Repository]()
    private weak var activityIndicatorView: UIActivityIndicatorView!
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Repositories"
        setupTableView()
        setupActivityIndicator()
        activityIndicatorView.startAnimating()
        fetchRepositories()
    }
    
    private func setupTableView() {
        RepositoryTableViewCell.registerCellNib(in: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
    }
    
    private func setupActivityIndicator() {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.backgroundView = activityIndicatorView
        self.activityIndicatorView = activityIndicatorView
    }
    
    @IBAction private func refresh(sender: UIRefreshControl){
        fetchRepositories()
        sender.endRefreshing()
    }
}

// MARK: - UITableViewDataSource&UITableViewDelegate
extension RepositoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RepositoryTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        
        cell.configure(repository: repositories[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RepositoryViewController.initial()
        vc.setRepository(repository: repositories[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Fetch repositories
extension RepositoriesViewController {
    
    func fetchRepositories() {
        repositoryService.getRepositoriesForAuthUser{ [weak self] result in
            switch result {
            case .success(let repositories):
                self?.repositories = repositories
                self?.activityIndicatorView.stopAnimating()
                self?.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
                self?.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
}
