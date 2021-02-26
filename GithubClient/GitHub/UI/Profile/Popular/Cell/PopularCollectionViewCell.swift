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
        getImage(url: repository.owner?.avatarUrl)
        
        guard repository.language != nil else {
            colorLanguageImage.isHidden = true
            return
        }
        
        languageLabel.text = repository.language
        let color = getLanguageColor(repository.language)
        colorLanguageImage.tintColor = color
        
        
        
    }
    
    private func getImage(url: String?) {
        guard let url = URL(string: url ?? "") else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self?.profileImage.image = image
                }
            }
        }.resume()
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
