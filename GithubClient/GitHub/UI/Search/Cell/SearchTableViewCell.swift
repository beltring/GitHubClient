//
//  SearchTableViewCell.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 3/1/21.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet private weak var menuImage: UIImageView!
    @IBOutlet private weak var searchLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        menuImage.tintColor = .black
    }
    
    // MARK: - set methods
    func setMenuImage(image: UIImage!) {
        menuImage.image = image
    }
    
    func setSearchLabelText(text: String) {
        searchLabel.text = text
    }
}
