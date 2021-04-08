//
//  CommitsViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/25/21.
//

import AMPopTip
import UIKit

class CommitsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var commitsUrl: String?
    private let commitsService = CommitsApiService()
    private var commitsData = [CommitData]()
    private var activityIndicatorView: UIActivityIndicatorView!
    private let popTip = PopTip()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        setupTableView()
        setupActivityIndicator()
        setupPopTip()
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
    
    private func setupNavigationItem() {
        self.navigationItem.title = "Commits"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .done, target: self, action: #selector(tappedInformation(_:)))
    }
    
    private func setupPopTip() {
        popTip.font = UIFont(name: "Avenir-Medium", size: 12)!
        popTip.shouldDismissOnTap = true
        popTip.edgeMargin = 5
        popTip.offset = 2
        popTip.bubbleOffset = 0
        popTip.edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        popTip.bubbleColor = UIColor(red: 0.31, green: 0.57, blue: 0.87, alpha: 1)
    }
    
    @objc func tappedInformation(_ sender: UIBarButtonItem) {
        let coordinates = CGRect(x: tableView.frame.maxX, y: 0, width: 0, height: 0)
        popTip.show(text: "Сommits from the default branch", direction: .autoHorizontal, maxWidth: 200, in: tableView, from: coordinates)
        var _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (_) in
            self.popTip.hide()
        }
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
