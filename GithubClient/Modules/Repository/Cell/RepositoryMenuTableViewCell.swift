//
//  RepositoryMenuTableViewCell.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/25/21.
//

import UIKit

class RepositoryMenuTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    func setTitleLabelText(text: String) {
        titleLabel.text = text
    }
}
