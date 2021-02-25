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
        profileImage.layer.cornerRadius = 15
        commitMessageLabel.text = commit.commit?.message
        userNameLabel.text = commit.committer?.login
        profileImage.image = nil
        getImage(url: commit.committer?.avatarUrl)
    }
    
    private func getImage(url: String?) {
        guard let url = URL(string: url ?? "") else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self?.profileImage.image = image
                }
            }
        }.resume()
    }
}

