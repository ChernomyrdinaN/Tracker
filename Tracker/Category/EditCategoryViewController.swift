//
//  EditCategoryViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 20.07.2025.
//

import UIKit

final class EditCategoryViewController: UIViewController {
    
    // MARK: - Properties
    private let keyboardHandler = KeyboardHandler()
    private let currentCategoryName: String
    var onSave: ((String) -> Void)?
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Редактирование категории"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = Colors.black
        label.textAlignment = .center
        return label
    }()
    
    private let nameTextField: UITextField = {
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
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.backgroundColor = Colors.black
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(Colors.white, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: - Lifecycle
    init(currentName: String) {
        self.currentCategoryName = currentName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        nameTextField.text = currentCategoryName
        setupViews()
        setupConstraints()
        setupActions()
        
        keyboardHandler.setup(for: self)
        nameTextField.delegate = self
        updateDoneButtonState()
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        [titleLabel, nameTextField, doneButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
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
    
    private func updateDoneButtonState() {
        let isEnabled = !(nameTextField.text?.isEmpty ?? true)
        doneButton.isEnabled = isEnabled
        let color = isEnabled ? Colors.black : Colors.gray
        doneButton.setBackgroundColor(color, for: .normal)
        doneButton.setBackgroundColor(color, for: .disabled)
    }
    
    // MARK: - Actions
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateDoneButtonState()
    }
    
    @objc private func doneButtonTapped() {
        guard let categoryName = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !categoryName.isEmpty else { return }
        onSave?(categoryName)
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension EditCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doneButtonTapped()
        return true
    }
}
