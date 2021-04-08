//
//  RepositoryTableViewCell.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/23/21.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var starCountLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var colorLanguageImage: UIImageView!
    
    override func prepareForReuse() {
        colorLanguageImage.isHidden = false
        starCountLabel.text = nil
        languageLabel.text = nil
        nameLabel.text = nil
        super.prepareForReuse()
    }
}

extension RepositoryTableViewCell {
    
    func configure(repository: Repository) {
        nameLabel.text = repository.name
        starCountLabel.text = String(repository.stargazersCount)
        
        guard repository.language != nil else {
            colorLanguageImage.isHidden = true
            return
        }
        
        languageLabel.text = repository.language
        let color = getLanguageColor(repository.language)
        colorLanguageImage.tintColor = color
    }
    
    private func getLanguageColor(_ language: String?) -> UIColor {
        switch language {
        case "Swift":
            return UIColor.orange
        case "Java":
            return UIColor.brown
        case "C#":
            return UIColor.green
        case "HTML":
            return UIColor.red
        case "JavaScript":
            return UIColor.yellow
        case "Python":
            return UIColor.magenta
        default:
            return UIColor.blue
        }
    }
}
