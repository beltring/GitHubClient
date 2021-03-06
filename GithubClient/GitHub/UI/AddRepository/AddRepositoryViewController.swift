//
//  AddRepositoryViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 3/6/21.
//

import UIKit

class AddRepositoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
