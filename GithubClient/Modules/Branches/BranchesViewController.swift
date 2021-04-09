//
//  BranchesViewController.swift
//  GithubClient
//
//  Created by user on 4/9/21.
//

import UIKit

class BranchesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        BranchTableViewCell.registerCellNib(in: tableView)
    }
}

// MARK: - Extensions
// MARK: - UITableViewDataSource
extension BranchesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BranchTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        
        return cell
    }
}

extension BranchesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
    }
}
