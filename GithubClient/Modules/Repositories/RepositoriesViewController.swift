//
//  RepositoriesViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/23/21.
//

import Moya
import UIKit

class RepositoriesViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var screen: RepositoryScreen = .all
    
    private var repositories = [Repository]()
    private var filteredRepositories = [Repository]()
    private var activityIndicatorView: UIActivityIndicatorView!
    private var searchText = ""
    private let searchController = UISearchController(searchResultsController: nil)
    private let provider = MoyaProvider<GitHubAPI>()
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupActivityIndicator()
        setupScreen()
        activityIndicatorView.startAnimating()
        navigationItem.title = screen.title
    }
    
    // MARK: - Setup
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
        case .all:
            getRepositories()
            tableView.refreshControl = refreshControl
            navigationItem.hidesSearchBarWhenScrolling = false
            setupSearchController()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(showAddRepositoryScreen))
        case .search:
            getSearchRepositories(searchText: searchText)
        case .starred:
            getStarredRepositories()
            setupSearchController()
        }
    }
    
    // MARK: - Actions
    @objc private func showAddRepositoryScreen() {
        let vc = AddRepositoryViewController.initial()
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction private func refresh(sender: UIRefreshControl) {
        getRepositories()
    }
    
    // MARK: - Get/Set methods
    func setSearchText(searchText: String) {
        self.searchText = searchText
    }
}

// MARK: - Extensions
// MARK: - UITableViewDataSource
extension RepositoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = isFiltering ? filteredRepositories.count : repositories.count
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RepositoryTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        
        let repos: Repository
        
        if isFiltering {
            repos = filteredRepositories[indexPath.row]
        } else {
            repos = repositories[indexPath.row]
        }
        
        cell.configure(repository: repos)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RepositoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repos: Repository
        
        if isFiltering {
            repos = filteredRepositories[indexPath.row]
        } else {
            repos = repositories[indexPath.row]
        }
        
        let vc = RepositoryViewController.initial()
        vc.setRepository(repository: repos)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - API calls
extension RepositoriesViewController {
    private func getRepositories() {
        provider.request(.getUserRepositories) { [weak self] result in
            self?.activityIndicatorView.stopAnimating()
            self?.refreshControl.endRefreshing()
            
            switch result {
            case .success(let response):
                do {
                let decoder = JSONDecoder()
                self?.repositories = try decoder.decode([Repository].self, from: response.data)
                self?.tableView.reloadData()
                } catch {
                    print("Decoding error")
                }
            case .failure(let error):
                self?.presentAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func getSearchRepositories(searchText: String) {
        provider.request(.getSearchRepositories(searchText)) { [weak self] result in
            self?.activityIndicatorView.stopAnimating()
            
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let reposData = try decoder.decode(RepositoriesData.self, from: response.data)
                    self?.repositories = reposData.repositories ?? [Repository]()
                    self?.tableView.reloadData()
                } catch {
                    print("Decoding error")
                }
            case .failure(let error):
                self?.presentAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func getStarredRepositories() {
        provider.request(.getStarredRepositories) { [weak self] result in
            self?.activityIndicatorView.stopAnimating()
            
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    self?.repositories = try decoder.decode([Repository].self, from: response.data)
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

// MARK: - Sreens repositories
enum RepositoryScreen {
    case all
    case starred
    case search
    
    var title: String {
        switch self {
        case .all:
            return "Repositories"
        case .search:
            return "Search results"
        case .starred:
            return "Starred Repositories"
        }
    }
}
