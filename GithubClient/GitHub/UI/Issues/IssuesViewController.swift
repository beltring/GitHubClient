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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        fetchIssues()
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
                print(issues.count)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
