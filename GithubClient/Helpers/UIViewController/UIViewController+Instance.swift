//
//  UIViewController+Instance.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/22/21.
//

import Foundation
import UIKit

extension UIViewController {
    static func initial() -> Self {
        let className = String(describing: self)
        
        let name = className.replacingOccurrences(of: "ViewController", with: "").replacingOccurrences(of: "Controller", with: "")
        
        let storyboard = UIStoryboard(name: name, bundle: nil)
        return instanceInitial(from: storyboard)
    }

    //MARK: - Private

    private class func instanceInitial<T: UIViewController>(from storyboard: UIStoryboard) -> T {
        return storyboard.instantiateInitialViewController() as! T
    }
}
