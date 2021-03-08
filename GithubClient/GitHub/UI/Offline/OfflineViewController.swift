//
//  OfflineViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 3/4/21.
//

import UIKit

class OfflineViewController: UIViewController {

    private let network = NetworkReachabilityManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        network.reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}
