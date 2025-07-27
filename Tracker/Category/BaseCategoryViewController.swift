//
//  BaseCategoryViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 27.07.2025.
//

import UIKit

class BaseCategoryViewController: UIViewController {
    // MARK: - UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = Colors.black
        label.textAlignment = .center
        return label
    }()
    
    let nameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Введите название категории"
        field.backgroundColor = Colors.background
        field.font = .systemFont(ofSize: 17, weight: .regular)
        field.tintColor = Colors.black
        field.layer.cornerRadius = 16
        field.layer.masksToBounds = true
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        field.leftViewMode = .always
        field.clearButtonMode = .whileEditing
        field.returnKeyType = .done
        return field
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = Colors.red
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.backgroundColor = Colors.gray
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(Colors.white, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        nameTextField.delegate = self
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = Colors.white
        
        [titleLabel, nameTextField, errorLabel, doneButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            errorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupActions() {
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Helper Methods
    func updateDoneButtonState() {
        let text = nameTextField.text ?? ""
        let isEnabled = !text.isEmpty && text.count <= Constants.maxCategoryNameLength
        doneButton.isEnabled = isEnabled
        doneButton.backgroundColor = isEnabled ? Colors.black : Colors.gray
    }
    
    // MARK: - Actions
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        let isErrorVisible = text.count > Constants.maxCategoryNameLength
        
        errorLabel.isHidden = !isErrorVisible
        
        if isErrorVisible {
            textField.text = String(text.prefix(Constants.maxCategoryNameLength))
        }
        
        updateDoneButtonState()
    }
    
    @objc func doneButtonTapped() {
    }
}

// MARK: - UITextFieldDelegate
extension BaseCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doneButtonTapped()
        return true
    }
}
