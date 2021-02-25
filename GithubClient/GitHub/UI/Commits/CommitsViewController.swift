//
//  CommitsViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/25/21.
//

import UIKit

class CommitsViewController: UIViewController {

    var commitsUrl: String?
    private let commitsService = CommitsApiService()
    private var commitsData = [CommitData]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        fetchCommits()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        CommitTableViewCell.registerCellNib(in: tableView)
    }
}

// MARK: - UITableViewDelegate&UITableViewDataSource
extension CommitsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CommitTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        
        return cell
    }
}

extension CommitsViewController {
    func fetchCommits() {
        guard let url = URL(string: commitsUrl ?? "") else { return }
        
        commitsService.getCommitsForDefaultBranch(url: url) { [weak self] result in
            switch result {
            case .success(let commits):
                self?.commitsData = commits
                self?.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
}
