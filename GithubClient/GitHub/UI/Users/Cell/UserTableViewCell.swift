//
//  UserTableViewCell.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 3/1/21.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    
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
