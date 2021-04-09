//
//  IssuesViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/26/21.
//

import Moya
import SafariServices
import UIKit

class IssuesViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var activityIndicatorView: UIActivityIndicatorView!
    private var issues = [Issue]()
    private var filteredIssues = [Issue]()
    private var filter: Filter = .all
    private let provider = MoyaProvider<GitHubAPI>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Issues"
        setupTableView()
        setupSearchBar()
        setupActivityIndicator()
        activityIndicatorView.startAnimating()
        getIssues()
    }
    
    // MARK: - Setup
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
    
    // MARK: - API calls
    private func getIssues(filter: String = "all") {
        provider.request(.getIssues(filter)) { [weak self] result in
            self?.activityIndicatorView.stopAnimating()
            
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    self?.issues = try decoder.decode([Issue].self, from: response.data)
                    self?.filteredIssues = try decoder.decode([Issue].self, from: response.data)
                    self?.tableView.reloadData()
                } catch {
                    print("Decoding error")
                }
            case .failure(let error):
                self?.presentAlert(message: error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension IssuesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            if isSearchBarEmpty {
                filteredIssues = issues
            }
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
}

// MARK: - UITableViewDelegate
extension IssuesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let issue: Issue
        
        if isFiltering {
            issue = filteredIssues[indexPath.row]
        } else {
            issue = issues[indexPath.row]
        }
        
        let url = URL(string: issue.url ?? "")
        presentSafariViewController(url: url)
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
        
        if self.filter != filter {
            activityIndicatorView.startAnimating()
            self.filter = filter
            
            switch filter {
            case .all:
                getIssues(filter: filter.rawValue)
            case .created:
                getIssues(filter: filter.rawValue)
            case .assigned:
                getIssues(filter: filter.rawValue)
            case .mentioned:
                getIssues(filter: filter.rawValue)
            }
        }
        
        if !isSearchBarEmpty {
            filteredIssues = issues.filter { (issue: Issue) -> Bool in
                return issue.title!.lowercased().contains(searchText.lowercased())
            }
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

// MARK: - Filter enum
private enum Filter: String, CaseIterable {
    case all
    case created
    case assigned
    case mentioned
}
