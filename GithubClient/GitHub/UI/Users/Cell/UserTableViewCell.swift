//
//  UserTableViewCell.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 3/1/21.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var loginLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = 20
    }
    
    override func prepareForReuse() {
        profileImage.image = nil
        loginLabel.text = nil
        super.prepareForReuse()
    }
}

// MARK: - Configure cell
extension UserTableViewCell {
    func configure(user: User) {
        loginLabel.text = user.login
        
        guard let url = URL(string: user.avatarUrl ?? "") else { return }
        profileImage.kf.setImage(with: url)
    }
}
