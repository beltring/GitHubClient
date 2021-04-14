//
//  PullRequestsViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/28/21.
//

import Moya
import UIKit

class PullRequestsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var pullRequestsUrl: String?
    
    private var pullRequests = [PullRequest]()
    private let provider = MoyaProvider<GitHubAPI>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Pull requests"
        getPullRequests()
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
    private func getPullRequests() {
        provider.request(.getPullRequests(pullRequestsUrl!)) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    self?.pullRequests = try decoder.decode([PullRequest].self, from: response.data)
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

// MARK: - Extensions
// MARK: - UITableViewDataSource
extension PullRequestsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = pullRequests.count
        
        if count == 0 {
            tableView.setEmptyView(title: "There are no pull requests in this repository", animated: true)
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
