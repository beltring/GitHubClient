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
    private var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupActivityIndicator()
        setupCollectionView()
        activityIndicatorView.startAnimating()
        fetchPopularRepository()
    }
    
    private func setupCollectionView() {
        PopularCollectionViewCell.registerCellNib(in: collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func setupActivityIndicator() {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        collectionView.backgroundView = activityIndicatorView
        self.activityIndicatorView = activityIndicatorView
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
        return CGSize(width: collectionView.bounds.width * Constants.cellWidthCoefficient, height: Constants.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
    }
}

// MARK: - Fetch popular repository
extension PopularViewController {
    private func fetchPopularRepository() {
        RepositoriesApiService().getRepositoriesForAuthUser { [weak self] result in
            self?.activityIndicatorView.stopAnimating()
            
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

fileprivate struct Constants {
    static let cellHeight: CGFloat = 170
    static let cellWidthCoefficient: CGFloat = 0.8
}
