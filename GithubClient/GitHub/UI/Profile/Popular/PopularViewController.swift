//
//  PopularViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/23/21.
//

import UIKit

class PopularViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var popularRepositories = [Repository]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        fetchPopularRepository()
    }
    
    private func setupCollectionView() {
        PopularCollectionViewCell.registerCellNib(in: collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

// MARK: - UICollectionViewDataSource&UICollectionViewDelegate
extension PopularViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularRepositories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PopularCollectionViewCell.dequeueReusableCell(in: collectionView, for: indexPath)
        
        let repository = popularRepositories[indexPath.item]
        cell.configure(repository: repository)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PopularViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 90, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 5)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 20
//    }
}

extension PopularViewController {
    func fetchPopularRepository() { 
        RepositoriesApiService().getRepositoriesForAuthUser { [weak self] result in
            switch result {
            case .success(let repositories):
                let repos = repositories.sorted(by: { (repos1, repos2) -> Bool in
                    return repos1.stargazersCount > repos2.stargazersCount ? true : false
                }).prefix(5)
                self?.popularRepositories = Array(repos)
                self?.collectionView.reloadData()
            case .failure(let error):
                self?.presentAlert(message: error.localizedDescription)
            }
        }
    }
}
