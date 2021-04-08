//
//  UIViewController+PresentingSafari.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 3/3/21.
//

import Foundation
import SafariServices

extension UIViewController {
    func presentSafariViewController(url: URL?) {
        guard let url = url else {
            return
        }
        
        let vc = self.makeSafariViewController(url: url)
        self.present(vc, animated: true)
    }

    func makeSafariViewController(url: URL) -> SFSafariViewController {
        let vc = SFSafariViewController(url: url)
        vc.delegate = UIViewController.safariDelegate
        
        return vc
    }
    
    private static let safariDelegate = WebViewControllerDelegate()
}

private class WebViewControllerDelegate: NSObject, SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
