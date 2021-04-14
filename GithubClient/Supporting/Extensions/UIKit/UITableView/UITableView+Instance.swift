//
//  UITableView+instance.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/28/21.
//

import Foundation
import Lottie
import UIKit

extension UITableView {
    func setEmptyView(title: String, animated: Bool = false) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        emptyView.addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        titleLabel.text = title
        if animated {
            titleLabel.text = ""
            let checkMarkAnimation =  AnimationView(name: "emptyAnimation")
            emptyView.contentMode = .scaleAspectFit
            emptyView.addSubview(checkMarkAnimation)
            checkMarkAnimation.frame = emptyView.bounds
            checkMarkAnimation.loopMode = .loop
            checkMarkAnimation.play()
        }
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
