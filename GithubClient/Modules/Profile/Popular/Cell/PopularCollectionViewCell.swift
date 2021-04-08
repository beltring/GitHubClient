//
//  PopularCollectionViewCell.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/23/21.
//

import Kingfisher
import UIKit

class PopularCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var nameRepositoryLabel: UILabel!
    @IBOutlet private weak var starCountLabel: UILabel!
    @IBOutlet private weak var colorLanguageImage: UIImageView!
    @IBOutlet private weak var languageLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = PopularConstants.imageCornerRadius
        layer.borderColor = UIColor.cellFrame.cgColor
        layer.borderWidth = PopularConstants.cellBorderWidth
        layer.cornerRadius = PopularConstants.cellCornerRadius
    }
    
    override func prepareForReuse() {
        colorLanguageImage.isHidden = false
        starCountLabel.text = nil
        languageLabel.text = nil
        nameRepositoryLabel.text = nil
        profileImage.image = nil
        userNameLabel.text = nil
        super.prepareForReuse()
    }
}

// MARK: - Setup
extension PopularCollectionViewCell {
    func configure(repository: Repository) {
        userNameLabel.text = repository.owner?.login
        nameRepositoryLabel.text = repository.name
        starCountLabel.text = String(repository.stargazersCount)
        
        guard repository.language != nil else {
            colorLanguageImage.isHidden = true
            return
        }
        
        languageLabel.text = repository.language
        let color = getLanguageColor(repository.language)
        colorLanguageImage.tintColor = color
        
        guard let url = URL(string: repository.owner?.avatarUrl ?? "") else { return }
        profileImage.kf.setImage(with: url)
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
