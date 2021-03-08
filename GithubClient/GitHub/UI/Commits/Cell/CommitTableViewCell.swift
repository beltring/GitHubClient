//
//  CommitTableViewCell.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/25/21.
//

import UIKit

class CommitTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commitMessageLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!

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

// MARK: - Configure cell
extension CommitTableViewCell {
    
    func configure(commit: CommitData) {
        commitMessageLabel.text = commit.commit?.message
        userNameLabel.text = commit.committer?.login
        profileImage.image = nil
        
        guard let url = URL(string: commit.committer?.avatarUrl ?? "") else { return }
        
        LoadService().getImage(url: url) { [weak self] result in
            switch result {
            case .success(let image):
                self?.profileImage.image = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

