//
//  RepositoryViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/24/21.
//

import UIKit

class RepositoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var forkCountLabel: UILabel!
    @IBOutlet weak var watchersCountLabel: UILabel!
    @IBOutlet weak var forkImage: UIImageView!
    
    private var repository: Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = repository?.name
        setupVC()
        setupTableView()
    }
    
    private func setupVC() {
        ownerImage.layer.cornerRadius = 35
        
        userNameLabel.text = repository?.owner?.login
        nameLabel.text = repository?.name
        starCountLabel.text = String(repository?.stargazersCount ?? 0)
        forkCountLabel.text = String(repository?.forksCount ?? 0)
        watchersCountLabel.text = String(repository?.watchersCount ?? 0)
        forkImage.image = UIImage(systemName: "arrow.branch")
        guard let url = URL(string: repository?.owner?.avatarUrl ?? "") else { return }
        
        LoadService().getImage(url: url) { [weak self] result in
            switch result {
            case .success(let image):
                self?.ownerImage.image = image
            case .failure(let error):
                self?.presentAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        RepositoryMenuTableViewCell.registerCellNib(in: tableView)
    }
    
    private func showRepositoryInBrowser() {
        guard let url = URL(string: repository?.url ?? "") else { return }
        presentSafariViewController(url: url)
    }
}

// MARK: - UITableViewDelegate&UITableViewDataSource
extension RepositoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(Rows.allCases.count)
        return Rows.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RepositoryMenuTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        
        cell.accessoryType = .disclosureIndicator
        cell.titleLabel.text = Rows.allCases[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = Rows.allCases[indexPath.row]
        
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

extension RepositoryViewController {
    
    // MARK: - Set method
    func setRepository(repository: Repository) {
        self.repository = repository
    }
    
    // MARK: - Show commits screen
    func showCommits() {
        let vc = CommitsViewController.initial()
        
        // api.github.com/repos/user/reposName/commits{/sha}
        vc.commitsUrl = repository?.commitsUrl?.replacingOccurrences(of: "{/sha}", with: "")
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Show pullRequests screen
    func showPullRequests() {
        let vc = PullRequestsViewController.initial()
        
        // https://api.github.com/repos/user/reposName/pulls{/number}
        let strUrl = repository?.pullUrl?.replacingOccurrences(of: "{/number}", with: "")
        guard let url = URL(string: strUrl!) else { return }
        vc.pullRequestsUrl = url
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - ROWS
fileprivate enum Rows: Int, CaseIterable {
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

