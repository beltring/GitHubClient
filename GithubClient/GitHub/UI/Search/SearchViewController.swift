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

        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        SearchTableViewCell.registerCellNib(in: tableView)
    }
    
    private func showRepositories() {
        let vc = RepositoriesViewController.initial()
        vc.screen = .search
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate&UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rows.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SearchTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        
        cell.searchLabel.text = Rows.allCases[indexPath.row].title + searchText
        cell.menuImage.image = Rows.allCases[indexPath.row].image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = Rows.allCases[indexPath.row]
        
        switch row {
        case .repositories:
            showRepositories()
        case .users:
            print("users")
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = #""\#(searchText)""#
        
        tableView.reloadData()
    }
}

fileprivate enum Rows: Int, CaseIterable {
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
