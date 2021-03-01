//
//  UserTableViewCell.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 3/1/21.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: NSLayoutConstraint!
    @IBOutlet weak var loginLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
