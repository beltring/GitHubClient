//
//  AddRepositoryViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 3/6/21.
//

import UIKit

class AddRepositoryViewController: UIViewController {

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var nameRepositoryTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var addReadmeSwitch: UISwitch!
    
    private let service = RepositoriesApiService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(createRepository))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @objc private func createRepository() {
        guard let name = nameRepositoryTextField.text,
              let description = descriptionTextField.text
              else { return }
        
        if name.isEmpty {
            presentAlert(message: "Enter the repository name")
            return
        }
        
        let selectedIndex = segmentControl.selectedSegmentIndex
        var isPrivate = false
        if segmentControl.titleForSegment(at: selectedIndex) == "Private" {
            isPrivate = true
        }
        
        let data = RepositoryData(name: name, description: description, isPrivate: isPrivate, IsReadme: addReadmeSwitch.isOn)
        sendData(data: data)
        
    }
}

// MARK: - Send data
extension AddRepositoryViewController {
    private func sendData(data: RepositoryData) {
        service.addRepository(data: data) { [weak self] result in
            switch result {
            case .success(let statusCode):
                if statusCode == 201 {
                    self?.dismiss(animated: true, completion: nil)
                }
                else {
                    self?.presentAlert(message: "Error, try again")
                }
            case .failure(let error):
                self?.presentAlert(message: error.localizedDescription)
            }
        }
    }
}
