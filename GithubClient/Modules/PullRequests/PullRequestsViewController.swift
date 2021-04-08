//
//  PullRequestsViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/28/21.
//

import UIKit

class PullRequestsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var pullRequestsUrl: URL?
    
    private let service = PullRequestApiService()
    private var pullRequests = [PullRequest]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Pull requests"
        fetchPullRequests(url: pullRequestsUrl!)
        setupTableView()
    }

    // MARK: - Setup
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        PullRequestTableViewCell.registerCellNib(in: tableView)
    }
    
    // MARK: - API calls
    private func fetchPullRequests(url: URL) {
        service.getPullRequest(url: url) { [weak self] result in
            switch result {
            case .success(let pulls):
                self?.pullRequests = pulls
                self?.tableView.reloadData()
            case .failure(let error):
                self?.presentAlert(message: error.localizedDescription)
            }
        }
    }
}

// MARK: - Extensions
// MARK: - UITableViewDataSource
extension PullRequestsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = pullRequests.count
        
        if count == 0 {
            tableView.setEmptyView(title: "There are no pull requests in this repository", message: "")
        } else {
            tableView.restore()
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PullRequestTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        
        let pull = pullRequests[indexPath.row]
        cell.configure(pullRequest: pull)
        
        return cell
    }
}

// MARK: - UITableViewDelegate&
extension PullRequestsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pullRequest = pullRequests[indexPath.row]
        let url = URL(string: pullRequest.url!)
        presentSafariViewController(url: url)
    }
}