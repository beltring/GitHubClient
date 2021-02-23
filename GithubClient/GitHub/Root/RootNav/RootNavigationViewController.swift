//
//  RootNavigationViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/22/21.
//

import UIKit
import KeychainSwift

class RootNavigationViewController: UINavigationController {

    private let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    func setRootController() {
        let vc: UIViewController
        
        if keychain.get("accessToken") != nil {
            vc = RootTabBarViewController.initial()
        }
        else {
            vc = LoginViewController.initial()
        }
        
        setViewControllers([vc], animated: false)
    }

}
