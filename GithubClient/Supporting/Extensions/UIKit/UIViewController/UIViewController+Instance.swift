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
    
    // MARK: - Private
    private class func instanceInitial<T: UIViewController>(from storyboard: UIStoryboard) -> T {
        return (storyboard.instantiateInitialViewController() as? T)!
    }
}

extension UIViewController {
    func presentAlert(title: String? = nil,
                      message: String? = nil,
                      preferredStyle: UIAlertController.Style = .alert,
                      cancelTitle: String = NSLocalizedString("Cancel", comment: ""),
                      cancelStyle: UIAlertAction.Style = .cancel,
                      cancelHandler: ((UIAlertAction) -> Void)? = nil,
                      otherActions: [UIAlertAction]? = nil,
                      animated: Bool = true,
                      completion: (() -> Void)? = nil) {
        
        DispatchQueue.main.async { [weak self] in
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            
            alert.addAction(UIAlertAction(title: cancelTitle, style: cancelStyle, handler: cancelHandler))
            otherActions?.forEach { alert.addAction($0) }
            
            self?.present(alert, animated: animated, completion: completion)
        }
    }
}
