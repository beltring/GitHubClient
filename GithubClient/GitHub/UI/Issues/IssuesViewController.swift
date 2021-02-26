//
//  IssuesViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/26/21.
//

import UIKit

class IssuesViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let issuesService = IssuesApiService()
    private var issues = [Issue]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Issues"
        setupTableView()
        setupSearchBar()
        fetchIssues()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        IssueTableViewCell.registerCellNib(in: tableView)
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension IssuesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = IssueTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        
        let issue = issues[indexPath.row]
        cell.configure(issue: issue)
        
        return cell
    }
    
    
}

// MARK: - UISearchResultsUpdating
extension IssuesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}

// MARK: - Fetch issues
extension IssuesViewController {
    func fetchIssues(filter: String = "all") {
        issuesService.getIssues { [weak self] result in
            switch result {
            case .success(let issues):
                self?.issues = issues
                self?.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
