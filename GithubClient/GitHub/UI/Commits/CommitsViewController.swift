//
//  CommitsViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/25/21.
//

import UIKit

class CommitsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var commitsUrl: String?
    private let commitsService = CommitsApiService()
    private var commitsData = [CommitData]()
    private var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Commits"
        setupTableView()
        setupActivityIndicator()
        self.activityIndicatorView.startAnimating()
        fetchCommits()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        CommitTableViewCell.registerCellNib(in: tableView)
        tableView.tableFooterView = UIView()
    }
    
    private func setupActivityIndicator() {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.backgroundView = activityIndicatorView
        self.activityIndicatorView = activityIndicatorView
    }
}

// MARK: - UITableViewDelegate&UITableViewDataSource
extension CommitsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commitsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CommitTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        
        cell.configure(commit: commitsData[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: commitsData[indexPath.row].url ?? "")
        presentSafariViewController(url: url)
    }
}

// MARK: - Fetch data
extension CommitsViewController {
    func fetchCommits() {
        guard let url = commitsUrl else { return }
        commitsService.getCommitsForDefaultBranch(url: url) { [weak self] result in
            self?.activityIndicatorView.stopAnimating()
            
            switch result {
            case .success(let commits):
                self?.commitsData = commits
                self?.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
                self?.tableView.reloadData()
            case .failure(let error):
                self?.presentAlert(message: error.localizedDescription)
            }
        }
    }
}
