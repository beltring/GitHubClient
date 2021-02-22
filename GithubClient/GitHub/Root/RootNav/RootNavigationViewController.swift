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
    

    func setRootController(){
        
        let vc: UIViewController = RootTabBarViewController.initial()
        
        setViewControllers([vc], animated: false)
    }

}
