//
//  CommitTableViewCell.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/25/21.
//

import UIKit

class CommitTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var commitMessageLabel: UILabel!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var profileImage: UIImageView!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = 15
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        commitMessageLabel.text = nil
        userNameLabel.text = nil
        profileImage.image = nil
    }
}

// MARK: - Setup
extension CommitTableViewCell {
    func configure(commit: CommitData) {
        commitMessageLabel.text = commit.commit?.message
        userNameLabel.text = commit.committer?.login
        profileImage.image = nil
        
        guard let url = URL(string: commit.committer?.avatarUrl ?? "") else { return }
        profileImage.kf.setImage(with: url)
    }
}
