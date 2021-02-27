//
//  IssueTableViewCell.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/26/21.
//

import UIKit

class IssueTableViewCell: UITableViewCell {

    @IBOutlet weak var issueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
}

extension IssueTableViewCell {
    func configure(issue: Issue) {
        let number = issue.number ?? 0
        issueLabel.text = getIssuePath(issue.repositoryUrl) + " #\(number)"
        titleLabel.text = issue.title
    }
    
    private func getIssuePath(_ reposUrl: String?) -> String {
        guard let reposUrl = reposUrl else {return ""}
        // https://api.github.com/repos/hawkrai/CATSdesigner/issues/106
        let repositoryUrl = reposUrl.replacingOccurrences(of: "https://api.github.com/repos/", with: "").split(separator: "/")
        let user = repositoryUrl[0]
        let repos = repositoryUrl[1]
        let path = String(user + "/" + repos)
        
        return path
    }
}
