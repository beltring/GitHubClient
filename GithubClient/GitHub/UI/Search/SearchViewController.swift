//
//  SearchViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/28/21.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search GitHub"
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        SearchTableViewCell.registerCellNib(in: tableView)
    }
    
    private func showRepositories() {
        let vc = RepositoriesViewController.initial()
        vc.screen = .search
        vc.setSearchText(searchText: searchText)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showUsers() {
        let vc = UsersViewController.initial()
        vc.setSearchText(searchText: searchText)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate&UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchText.isEmpty {
            tableView.setEmptyView(title: "Enter the text", message: "")
            return 0
        }
        
        tableView.restore()
        return Row.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SearchTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        
        let searchText = #""\#(self.searchText)""#
        cell.searchLabel.text = Row.allCases[indexPath.row].title + searchText
        cell.menuImage.image = Row.allCases[indexPath.row].image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = Row.allCases[indexPath.row]
        
        switch row {
        case .repositories:
            showRepositories()
        case .users:
            showUsers()
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        
        tableView.reloadData()
    }
}

// MARK: - Rows
fileprivate enum Row: Int, CaseIterable {
    case repositories
    case users
    
    var title: String {
        switch self {
        case .repositories:
            return "Repositories with "
        case .users:
            return "People with "
        }
    }
    
    var image: UIImage? {
        switch self {
        case .repositories:
            return UIImage(systemName: "book.closed")
        case .users:
            return UIImage(systemName: "person")
        }
    }
}
