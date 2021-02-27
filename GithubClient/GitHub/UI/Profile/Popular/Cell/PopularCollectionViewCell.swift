//
//  PopularCollectionViewCell.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/23/21.
//

import UIKit

class PopularCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameRepositoryLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var colorLanguageImage: UIImageView!
    @IBOutlet weak var languageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = 17
        layer.borderColor = UIColor.cellFrame.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        colorLanguageImage.isHidden = false
        starCountLabel.text = nil
        languageLabel.text = nil
        nameRepositoryLabel.text = nil
        profileImage.image = nil
    }
}

// MARK: -  Configure cell
extension PopularCollectionViewCell {
    func configure(repository: Repository) {
        userNameLabel.text = repository.owner?.login
        nameRepositoryLabel.text = repository.name
        starCountLabel.text = String (repository.stargazersCount)
        
        guard let url = URL(string: repository.owner?.avatarUrl ?? "") else { return }
        LoadService().getImage(url: url) { [weak self] result in
            switch result {
            case .success(let image):
                self?.profileImage.image = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
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
        default:
            return UIColor.blue
        }
    }
}
