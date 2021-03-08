//
//  PullRequestTableViewCell.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/28/21.
//

import UIKit

class PullRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var pullLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        pullLabel.text = nil
        titleLabel.text = nil
        super.prepareForReuse()
    }
}

// MARK: - Configure cell
extension PullRequestTableViewCell {
    func configure(pullRequest: PullRequest) {
        titleLabel.text = pullRequest.title
        let number = pullRequest.number ?? 0
        pullLabel.text = getPullPath(pullRequest.issueUrl) + " #\(number)"
        
    }
    
    private func getPullPath(_ issueUrl: String?) -> String {
        guard let issueUrl = issueUrl else {return ""}
        // https://api.github.com/repos/hawkrai/CATSdesigner/issues/106
        let strArray = issueUrl.replacingOccurrences(of: "https://api.github.com/repos/", with: "").split(separator: "/")
        let user = strArray[0]
        let repos = strArray[1]
        let path = String(user + "/" + repos)
        
        return path
    }
}
