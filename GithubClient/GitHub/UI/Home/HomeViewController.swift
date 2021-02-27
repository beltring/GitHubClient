//
//  HomeViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/22/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    private func showPullRequests() {
        
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
        case .pullRequests:
            showRepositories()
        case .issues:
            showIssues()
        }
    }
}

// MARK: ROWS
fileprivate enum Row: Int, CaseIterable {
    case repositories
    case pullRequests
    case issues

    var image: UIImage? {
        switch self {
        case .repositories:
            return UIImage(named: "repositories")
        case .pullRequests:
            return UIImage(named: "pullRequests")
        case .issues:
            return UIImage(named: "issue")
        }
    }
    
    var title: String {
        switch self {
        case .repositories:
            return "Repositories"
        case .pullRequests:
            return "Pull Requests"
        case .issues:
            return "Issues"
        }
    }
}
