//
//  HomeViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/22/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private let network = NetworkReachabilityManager.sharedInstance
    private var starredRepositories = [Repository]()
    
    // MARK: - Lifecycle
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
        setupTableView()
    }

    // MARK: - Setup
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        MenuTableViewCell.registerCellNib(in: tableView)
        tableView.layer.cornerRadius = 10
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Navigation
    private func showRepositories() {
        let vc = RepositoriesViewController.initial()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showStarred() {
        let vc = RepositoriesViewController.initial()
        vc.screen = .starred
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showIssues() {
        let vc = IssuesViewController.initial()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Extensions
// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MenuTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        let text = Row.allCases[indexPath.row].title
        let image = Row.allCases[indexPath.row].image
        cell.setTitleLabelText(text: text)
        cell.setMenuIconImageView(image: image)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
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
private enum Row: Int, CaseIterable {
    case repositories
    case starred
    case issues

    var image: UIImage? {
        switch self {
        case .repositories:
            return UIImage(named: "icRepositories")
        case .starred:
            return UIImage(named: "icStarred")
        case .issues:
            return UIImage(named: "icIssue")
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
