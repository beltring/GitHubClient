//
//  BranchTableViewCell.swift
//  GithubClient
//
//  Created by user on 4/9/21.
//

import UIKit

class BranchTableViewCell: UITableViewCell {

    @IBOutlet private weak var branchLabel: UILabel!
    @IBOutlet private weak var markImage: UIImageView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Setup
    func setup(branchName: String, isDefault: Bool = false) {
        branchLabel.text = branchName
        markImage.isHidden = isDefault
    }
    
}
