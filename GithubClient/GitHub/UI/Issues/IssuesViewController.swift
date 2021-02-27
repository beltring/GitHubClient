//
//  IssuesViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/26/21.
//

import UIKit
import SafariServices

class IssuesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private weak var activityIndicatorView: UIActivityIndicatorView!
    private let issuesService = IssuesApiService()
    private var issues = [Issue]()
    private var filteredIssues = [Issue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Issues"
        setupTableView()
        setupSearchBar()
        setupActivityIndicator()
        activityIndicatorView.startAnimating()
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
        searchController.searchBar.scopeButtonTitles = Filter.allCases.map { $0.rawValue }
        searchController.searchBar.delegate = self
        searchController.resignFirstResponder()
    }
    
    private func setupActivityIndicator() {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        tableView.backgroundView = activityIndicatorView
        self.activityIndicatorView = activityIndicatorView
    }
}

// MARK: - UITableViewDelegate&UITableViewDataSource
extension IssuesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredIssues.count
        }
        
        return issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = IssueTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        let issue: Issue
        
        if isFiltering {
            issue = filteredIssues[indexPath.row]
        } else {
            issue = issues[indexPath.row]
        }
        
        cell.configure(issue: issue)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let issue: Issue
        
        if isFiltering {
            issue = filteredIssues[indexPath.row]
        } else {
            issue = issues[indexPath.row]
        }
        
        guard let url = URL(string: issue.url ?? "") else { return }
        showIssueInBrowser(url: url)
    }
}

// MARK: - Fetch issues
extension IssuesViewController {
    func fetchIssues(filter: String = "all") {
        issuesService.getIssues(filter: filter) { [weak self] result in
            self?.activityIndicatorView.stopAnimating()
            
            switch result {
            case .success(let issues):
                self?.issues = issues
                self?.filteredIssues = issues
                self?.tableView.reloadData()
            case .failure(let error):
                self?.presentAlert(message: error.localizedDescription)
            }
        }
    }
}

// MARK: - UISearchResultsUpdating & UISearch configure
extension IssuesViewController: UISearchResultsUpdating {
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
          return searchController.isActive &&
            (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
          let filter = Filter(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
          filterContentForSearchText(searchBar.text!, filter: filter!)
    }
    
    private func filterContentForSearchText(_ searchText: String, filter: Filter = .all) {
        activityIndicatorView.startAnimating()
        
        switch filter {
        case .all:
            fetchIssues(filter: filter.rawValue)
        case .created:
            fetchIssues(filter: filter.rawValue)
        case .assigned:
            fetchIssues(filter: filter.rawValue)
        case .mentioned:
            fetchIssues(filter: filter.rawValue)
        }
        
        filteredIssues = issues.filter { (issue: Issue) -> Bool in
            return issue.title!.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension IssuesViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    
    guard let filter = Filter(rawValue: searchBar.scopeButtonTitles![selectedScope]) else { return }
    filterContentForSearchText(searchBar.text!, filter: filter)
  }
}

// MARK: - SFSafariViewControllerDelegate
extension IssuesViewController: SFSafariViewControllerDelegate {
    func showIssueInBrowser(url: URL) {
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - Filter
private enum Filter: String, CaseIterable {
    case all
    case created
    case assigned
    case mentioned
}