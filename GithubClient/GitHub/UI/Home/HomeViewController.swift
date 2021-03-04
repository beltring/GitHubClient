//
//  HomeViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/22/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let repositoryService = RepositoriesApiService()
    private var starredRepositories = [Repository]()
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
        
        searchBar.delegate = self
        fetchStarredRepositories()
        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        MenuTableViewCell.registerCellNib(in: tableView)
        tableView.layer.cornerRadius = 10
        tableView.tableFooterView = UIView()
    }
    
    private func showRepositories() {
        let vc = RepositoriesViewController.initial()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showStarred() {
        let vc = RepositoriesViewController.initial()
        vc.setRepositories(repositories: starredRepositories)
        vc.screen = .starred
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showIssues() {
        let vc = IssuesViewController.initial()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource&UITableViewDelegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MenuTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        cell.titleLabel.text = Row.allCases[indexPath.row].title
        cell.menuIconImageView.image = Row.allCases[indexPath.row].image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = Row.allCases[indexPath.row]
        
        switch row {
        case .repositories:
            showRepositories()
        case .starred:
            showStarred()
        case .issues:
            showIssues()
        }
    }
}

// MARK: - Fetch starred repositories
extension HomeViewController {
    func fetchStarredRepositories() {
        repositoryService.getStarredRepositories { [weak self] result in
            switch result {
            case .success(let repositories):
                self?.starredRepositories = repositories
                self?.tableView.reloadData()
            case .failure(let error):
                self?.presentAlert(message: error.localizedDescription)
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.endEditing(true)
        let vc = SearchViewController.initial()
        vc.navigationItem.title = "Search"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - ROWS
fileprivate enum Row: Int, CaseIterable {
    case repositories
    case starred
    case issues

    var image: UIImage? {
        switch self {
        case .repositories:
            return UIImage(named: "repositories")
        case .starred:
            return UIImage(named: "starred")
        case .issues:
            return UIImage(named: "issue")
        }
    }
    
    var title: String {
        switch self {
        case .repositories:
            return "Repositories"
        case .starred:
            return "Starred"
        case .issues:
            return "Issues"
        }
    }
}
