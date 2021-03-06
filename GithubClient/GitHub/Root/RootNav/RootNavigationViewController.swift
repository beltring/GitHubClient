//
//  RootNavigationViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/22/21.
//

import UIKit

class RootNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setRootController() {
        let vc: UIViewController
        
        if AuthorizeData.shared.isAuthorized {
            vc = RootTabBarViewController.initial()
        }
        else {
            vc = LoginViewController.initial()
        }
        
        setViewControllers([vc], animated: false)
    }

}
