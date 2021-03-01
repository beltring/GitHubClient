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
    private let searchService = SearchApiService()
    private var repositories = [Repository]()
    private var filteredRepositories = [Repository]()
    private weak var activityIndicatorView: UIActivityIndicatorView!
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchText = ""
    var screen: Screen = .repositories
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupActivityIndicator()
        setupScreen()
    }
    
    @IBAction private func refresh(sender: UIRefreshControl) {
        fetchRepositories()
        sender.endRefreshing()
    }
    
    private func setupTableView() {
        RepositoryTableViewCell.registerCellNib(in: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    private func setupActivityIndicator() {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        tableView.backgroundView = activityIndicatorView
        self.activityIndicatorView = activityIndicatorView
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupScreen() {
        switch screen {
        case .repositories:
            navigationItem.title = screen.title
            activityIndicatorView.startAnimating()
            fetchRepositories()
            tableView.refreshControl = refreshControl
            navigationItem.hidesSearchBarWhenScrolling = false
            setupSearchController()
        case .search:
            fetchSearchRepositories(searchText: searchText)
            activityIndicatorView.startAnimating()
            navigationItem.title = screen.title
        case .starred:
            navigationItem.title = screen.title
            setupSearchController()
        }
    }
}

// MARK: - Get/Set methods
extension RepositoriesViewController {
    func setRepositories(repositories: [Repository]) {
        self.repositories = repositories
    }
    
    func setSearchText(searchText: String) {
        self.searchText = searchText
    }
}

// MARK: - UITableViewDataSource&UITableViewDelegate
extension RepositoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = isFiltering ? filteredRepositories.count : repositories.count
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RepositoryTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        
        let repos: Repository
        
        if isFiltering {
            repos = filteredRepositories[indexPath.row]
        }
        else {
            repos = repositories[indexPath.row]
        }
        
        cell.configure(repository: repos)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RepositoryViewController.initial()
        let repos: Repository
        
        if isFiltering {
            repos = filteredRepositories[indexPath.row]
        }
        else {
            repos = repositories[indexPath.row]
        }
        
        vc.setRepository(repository: repos)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Fetch repositories
extension RepositoriesViewController {
    
    private func fetchRepositories() {
        repositoryService.getRepositoriesForAuthUser { [weak self] result in
            self?.activityIndicatorView.stopAnimating()
            
            switch result {
            case .success(let repositories):
                self?.repositories = repositories
                self?.tableView.reloadData()
            case .failure(let error):
                self?.presentAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func fetchSearchRepositories(searchText: String) {
        searchService.getRepositoriesBySearchText(searchText: searchText) { [weak self] result in
            self?.activityIndicatorView.stopAnimating()
            
            switch result {
            case .success(let repositoriesData):
                self?.repositories = repositoriesData.repositories ?? [Repository]()
                self?.tableView.reloadData()
            case .failure(let error):
                self?.presentAlert(message: error.localizedDescription)
            }
        }
    }
}

// MARK: - UISearchResultsUpdating & Search repositories
extension RepositoriesViewController: UISearchResultsUpdating {
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
      filteredRepositories = repositories.filter { (repos: Repository) -> Bool in
        return repos.name.lowercased().contains(searchText.lowercased())
      }
      
      tableView.reloadData()
    }
}


enum Screen {
    case repositories
    case starred
    case search
    
    var title: String {
        switch self {
        case .repositories:
            return "Repositories"
        case .search:
            return "Search results"
        case .starred:
            return "Starred Repositories"
        }
    }
}
