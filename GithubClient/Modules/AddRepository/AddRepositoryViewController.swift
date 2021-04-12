//
//  AddRepositoryViewController.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 3/6/21.
//

import Moya
import SkyFloatingLabelTextField
import UIKit

class AddRepositoryViewController: UIViewController {
    
    @IBOutlet private weak var navItem: UINavigationItem!
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var addReadmeSwitch: UISwitch!
    @IBOutlet private weak var textFieldsStackView: UIStackView!
    
    private var repositoryTextField: SkyFloatingLabelTextFieldWithIcon!
    private var descriptionTextField: SkyFloatingLabelTextField!
    private let provider = MoyaProvider<GitHubAPI>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(createRepository))
        setupTextFields()
    }
    
    // MARK: - Setup
    private func setupTextFields() {
        let indigoColor = UIColor(red: 86, green: 0, blue: 130/255, alpha: 1.0)
        let textFieldframe = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        repositoryTextField = SkyFloatingLabelTextFieldWithIcon(frame: textFieldframe, iconType: .image)
        repositoryTextField.placeholder = "Name"
        repositoryTextField.title = "Repository name"
        repositoryTextField.iconImage = UIImage(systemName: "book.closed")
        repositoryTextField.selectedLineColor = indigoColor
        repositoryTextField.selectedTitleColor = indigoColor
        self.textFieldsStackView.addArrangedSubview(repositoryTextField)

        descriptionTextField = SkyFloatingLabelTextField(frame: textFieldframe)
        descriptionTextField.placeholder = "Description (optional)"
        descriptionTextField.title = "Description"
        descriptionTextField.selectedTitleColor = indigoColor
        descriptionTextField.selectedLineColor = indigoColor
        self.textFieldsStackView.addArrangedSubview(descriptionTextField)
    }
    
    // MARK: - Actions
    @objc private func createRepository() {
        guard let name = repositoryTextField.text,
              let description = descriptionTextField.text
        else { return }
        
        if name.isEmpty {
            presentHUD(content: .labeledError(title: "Enter the repository name", subtitle: nil), delay: 1)
            return
        }
        
        let selectedIndex = segmentControl.selectedSegmentIndex
        var isPrivate = false
        if segmentControl.titleForSegment(at: selectedIndex) == "Private" {
            isPrivate = true
        }
        
        let data = RepositoryData(name: name, description: description, isPrivate: isPrivate, isReadme: addReadmeSwitch.isOn)
        addRepository(data: data)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - API calls
    private func addRepository(data: RepositoryData) {
        provider.request(.addRepositories(data)) { [weak self] result in
            switch result {
            case .success(let response):
                if response.statusCode == 201 {
                    self?.presentHUD(content: .success)
                    self?.dismiss(animated: true, completion: nil)
                } else {
                    self?.presentHUD(content: .labeledError(title: "Error, try again", subtitle: nil), delay: 1)
                }
            case .failure(let error):
                self?.presentAlert(message: error.localizedDescription)
            }
        }
    }
}
