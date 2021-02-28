//
//  SearchTableViewCell.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 3/1/21.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var searchLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        menuImage.tintColor = .black
    }
    
}
