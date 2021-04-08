//
//  MenuTableViewCell.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/22/21.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var menuIconImageView: UIImageView!
    
    func setTitleLabelText(text: String) {
        titleLabel.text = text
    }
    
    func setMenuIconImageView(image: UIImage!) {
        menuIconImageView.image = image
    }
}
