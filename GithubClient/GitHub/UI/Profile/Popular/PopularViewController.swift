//
//  PopularViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/23/21.
//

import UIKit

class PopularViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = PopularCollectionViewCell.dequeueReusableCell(in: collectionView, for: indexPath)
        cell.layer.borderColor = UIColor.Popular.cellFrame.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        
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
