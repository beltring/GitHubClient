//
//  BranchesViewController.swift
//  GithubClient
//
//  Created by user on 4/9/21.
//

import UIKit

class BranchesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var branches = [Branch]()
    var defaultBranch: String = ""
    var closure: ((String) -> Void)?
    
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
        return branches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BranchTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        
        let branch = branches[indexPath.row]
        if branch.name != defaultBranch {
            cell.setup(branchName: branch.name!)
        } else {
            cell.setup(branchName: branch.name!, isDefault: false)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension BranchesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let branch = branches[indexPath.row]
        closure?(branch.name!)
        self.dismiss(animated: true, completion: nil)
    }
}
