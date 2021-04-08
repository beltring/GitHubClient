//
//  RepositoryViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/24/21.
//

import Kingfisher
import UIKit

class RepositoryViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var ownerImage: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var starCountLabel: UILabel!
    @IBOutlet private weak var forkCountLabel: UILabel!
    @IBOutlet private weak var watchersCountLabel: UILabel!
    @IBOutlet private weak var forkImage: UIImageView!
    @IBOutlet private weak var branchLabel: UILabel!
    
    private var repository: Repository?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = repository?.name
        setupVC()
        setupTableView()
    }
    
    // MARK: - Setup
    private func setupVC() {
        ownerImage.layer.cornerRadius = 35
        var branch = repository?.defaultBranch ?? ""
        if !branch.isEmpty {
            branch += " branch"
        }
        
        userNameLabel.text = repository?.owner?.login
        nameLabel.text = repository?.name
        starCountLabel.text = String(repository?.stargazersCount ?? 0)
        forkCountLabel.text = String(repository?.forksCount ?? 0)
        watchersCountLabel.text = String(repository?.watchersCount ?? 0)
        branchLabel.text = branch
        forkImage.image = UIImage(systemName: "arrow.branch")
        
        guard let url = URL(string: repository?.owner?.avatarUrl ?? "") else { return }
        ownerImage.kf.setImage(with: url)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        RepositoryMenuTableViewCell.registerCellNib(in: tableView)
    }
    
    // MARK: - Get/Set methods
    func setRepository(repository: Repository) {
        self.repository = repository
    }
    
    // MARK: - Navigation
    private func showRepositoryInBrowser() {
        let url = URL(string: repository!.url)
        presentSafariViewController(url: url)
    }
    
    func showCommits() {
        let vc = CommitsViewController.initial()
        
        // api.github.com/repos/user/reposName/commits{/sha}
        vc.commitsUrl = repository?.commitsUrl?.replacingOccurrences(of: "{/sha}", with: "")
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showPullRequests() {
        let vc = PullRequestsViewController.initial()
        
        // https://api.github.com/repos/user/reposName/pulls{/number}
        let strUrl = repository?.pullUrl?.replacingOccurrences(of: "{/number}", with: "")
        guard let url = URL(string: strUrl!) else { return }
        vc.pullRequestsUrl = url
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Extensions
// MARK: - UITableViewDataSource
extension RepositoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RepositoryMenuTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        
        let text = Row.allCases[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        cell.setTitleLabelText(text: text)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RepositoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = Row.allCases[indexPath.row]
        
        switch row {
        case .commits:
            showCommits()
        case .code:
            showRepositoryInBrowser()
        case .pullRequests:
            showPullRequests()
        }
    }
}

// MARK: - ROWS
private enum Row: Int, CaseIterable {
    case commits
    case code
    case pullRequests
    
    var title: String {
        switch self {
        case .commits:
            return "Commits"
        case .code:
            return "Browse code"
        case .pullRequests:
            return "Pull Requests"
        }
    }
}
