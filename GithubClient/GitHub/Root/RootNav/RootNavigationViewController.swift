//
//  RootNavigationViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/22/21.
//

import UIKit

class RootNavigationViewController: UINavigationController {

    private var isLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    func setRootController() {
        let vc: UIViewController
        
        if isLogin {
            vc = RootTabBarViewController.initial()
        }
        else {
            vc = LoginViewController.initial()
        }
        
        setViewControllers([vc], animated: false)
    }

}
