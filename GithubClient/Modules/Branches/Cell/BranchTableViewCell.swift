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
    
    // MARK: - Setup
    func setup(branchName: String, isDefault: Bool = true) {
        branchLabel.text = branchName
        markImage.isHidden = isDefault
    }
    
}
