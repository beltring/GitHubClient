//
//  RepositoryViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/24/21.
//

import UIKit

class RepositoryViewController: UIViewController {
    
    private var repository: Repository?

    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var forkCountLabel: UILabel!
    @IBOutlet weak var watchersCountLabel: UILabel!
    @IBOutlet weak var forkImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupVC()
    }
    
    private func setupVC() {
        nameLabel.text = repository?.name
        starCountLabel.text = String(repository?.stargazersCount ?? 0)
        forkCountLabel.text = String(repository?.forksCount ?? 0)
        watchersCountLabel.text = String(repository?.watchersCount ?? 0)
        forkImage.image = UIImage(named: "arrow.branch")
    }
    
    // MARK: - Get image data
    private func getImageDataFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle Error
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.ownerImage.image = image
                }
            }
        }.resume()
    }
}

// MARK: - Get/Set methods
extension RepositoryViewController {
    
    func setRepository(repository: Repository) {
        self.repository = repository
    }
}

