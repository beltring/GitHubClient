//
//  PopularViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/23/21.
//

import AMPopTip
import Moya
import UIKit

class PopularViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var popularLabel: UILabel!
    
    private let popTip = PopTip()
    private var popularRepositories = [Repository]()
    private var activityIndicatorView: UIActivityIndicatorView!
    private let provider = MoyaProvider<GitHubAPI>()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedLabel(_:)))
        popularLabel.isUserInteractionEnabled = true
        popularLabel.addGestureRecognizer(tap)
        setupActivityIndicator()
        setupCollectionView()
        setupPopTip()
        activityIndicatorView.startAnimating()
        fetchPopularRepository()
    }
    
    // MARK: - Setup
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
    
    private func setupPopTip() {
        popTip.font = UIFont(name: "Avenir-Medium", size: 12)!
        popTip.shouldDismissOnTap = true
        popTip.actionAnimation = .bounce(8)
        popTip.edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        popTip.bubbleColor = UIColor(red: 0.31, green: 0.57, blue: 0.87, alpha: 1)
    }
    
    // MARK: - Actions
    @objc private func tappedLabel(_ sender: UITapGestureRecognizer? = nil) {
        popTip.show(text: "Most popular repositories this user", direction: .autoHorizontal, maxWidth: 200, in: view, from: popularLabel.frame)
        var _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (_) in
            self.popTip.hide()
        }
    }
    
    // MARK: - API calls
    private func fetchPopularRepository() {
        provider.request(.getUserRepositories) { [weak self] result in
            self?.activityIndicatorView.stopAnimating()
            
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let repos = try decoder.decode([Repository].self, from: response.data)
                    let popular = repos.sorted(by: { (repos1, repos2) -> Bool in
                        return repos1.stargazersCount > repos2.stargazersCount ? true : false
                    }).prefix(5)
                    self?.popularRepositories = Array(popular)
                    self?.collectionView.reloadData()
                } catch {
                    print("Decoding error")
                }
            case .failure(let error):
                self?.presentAlert(message: error.localizedDescription)
            }
        }
    }
}

// MARK: - Extensions
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
        return CGSize(width: collectionView.bounds.width * PopularConstants.cellWidthCoefficient,
                      height: PopularConstants.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
    }
}
