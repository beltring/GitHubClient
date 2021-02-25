//
//  RepositoryViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/24/21.
//

import UIKit
import SafariServices

class RepositoryViewController: UIViewController {
    
    private var repository: Repository?

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var forkCountLabel: UILabel!
    @IBOutlet weak var watchersCountLabel: UILabel!
    @IBOutlet weak var forkImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        getImageDataFrom(url: url)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        RepositoryMenuTableViewCell.registerCellNib(in: tableView)
    }
    
    // MARK: - Get image data
    private func getImageDataFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle Error
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.ownerImage.image = image
                }
            }
        }.resume()
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
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate&UITableViewDataSource
extension RepositoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Rows.allCases.count
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
        }
    }
}

extension RepositoryViewController: SFSafariViewControllerDelegate {
    
    private func showRepositoryInBrowser() {
        guard let url = URL(string: repository?.url ?? "") else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
}

// MARK: - ROWS
fileprivate enum Rows: Int, CaseIterable {
    case commits
    case code
    
    var title: String {
        switch self {
        case .commits:
            return "Commits"
        case .code:
            return "Browse code"
        }
    }
}

