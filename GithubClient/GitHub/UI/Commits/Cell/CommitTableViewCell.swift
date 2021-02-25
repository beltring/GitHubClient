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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
