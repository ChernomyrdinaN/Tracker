//
//  HabitCreationViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 19.06.2025.
//

import UIKit

final class HabitCreationViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let nameTextField = UITextField()
    private let clearTextFieldButton = UIButton(type: .system)
    private let errorLabel = UILabel()
    private let categoryButton = UIButton()
    private let scheduleButton = UIButton()
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    
    private let maxHabitNameLength = 38
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupTextField()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        // Настройка заголовка
        titleLabel.text = "Новая привычка"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        // Настройка поля ввода
        nameTextField.placeholder = "Введите название трекера"
        nameTextField.backgroundColor = Colors.background
        nameTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        nameTextField.textColor = .black
        nameTextField.layer.cornerRadius = 16
        nameTextField.layer.masksToBounds = true
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        nameTextField.leftViewMode = .always
        
        // Кнопка очистки текста
        clearTextFieldButton.setImage(UIImage(named: "xmark_circle"), for: .normal)
        clearTextFieldButton.tintColor = Colors.gray
        clearTextFieldButton.isHidden = true
        clearTextFieldButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        
        // Лейбл ошибки
        errorLabel.text = "Ограничение 38 символов"
        errorLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        errorLabel.textColor = Colors.red
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true
        
        // Настройка кнопок вместо таблицы
        setupButton(categoryButton, title: "Категория", isFirst: true)
        setupButton(scheduleButton, title: "Расписание", isFirst: false)
        
        categoryButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        scheduleButton.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)
        
        // Кнопки внизу экрана
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.backgroundColor = .clear
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.setTitleColor(Colors.red, for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = Colors.red?.cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        createButton.setTitle("Создать", for: .normal)
        createButton.backgroundColor = Colors.gray
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.setTitleColor(.white, for: .normal)
        createButton.isEnabled = false
        createButton.layer.cornerRadius = 16
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        [titleLabel, nameTextField, clearTextFieldButton, errorLabel,
         categoryButton, scheduleButton, cancelButton, createButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupButton(_ button: UIButton, title: String, isFirst: Bool) {
        // Создаем контейнер для содержимого
        let container = UIView()
        container.isUserInteractionEnabled = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .black
        
        let arrow = UIImageView(image: UIImage(named: "chevron"))
        arrow.tintColor = Colors.gray
        
        container.addSubview(titleLabel)
        container.addSubview(arrow)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        arrow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            arrow.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            arrow.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            arrow.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -24)
        ])
        
        button.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16),
            container.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            container.heightAnchor.constraint(equalTo: button.heightAnchor)
        ])
        
        button.backgroundColor = Colors.background
        button.layer.cornerRadius = 16
        button.layer.maskedCorners = isFirst ?
            [.layerMinXMinYCorner, .layerMaxXMinYCorner] :
            [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        if isFirst {
            let separator = UIView()
            separator.backgroundColor = Colors.gray
            button.addSubview(separator)
            separator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                separator.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16),
                separator.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16),
                separator.bottomAnchor.constraint(equalTo: button.bottomAnchor),
                separator.heightAnchor.constraint(equalToConstant: 0.5)
            ])
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Заголовок
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Поле ввода
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            // Кнопка очистки
            clearTextFieldButton.centerYAnchor.constraint(equalTo: nameTextField.centerYAnchor),
            clearTextFieldButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor, constant: -16),
            clearTextFieldButton.widthAnchor.constraint(equalToConstant: 20),
            clearTextFieldButton.heightAnchor.constraint(equalToConstant: 20),
            
            // Лейбл ошибки
            errorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            errorLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor, constant: -16),
            
            // Кнопки категории и расписания
            categoryButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 32),
            categoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            
            scheduleButton.topAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            scheduleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleButton.heightAnchor.constraint(equalToConstant: 75),
            
            // Кнопки внизу
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Actions
    @objc private func clearTextField() {
        nameTextField.text = ""
        clearTextFieldButton.isHidden = true
        errorLabel.isHidden = true
        updateCreateButtonState()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        clearTextFieldButton.isHidden = text.isEmpty
        errorLabel.isHidden = text.count <= maxHabitNameLength
        if text.count > maxHabitNameLength {
            textField.text = String(text.prefix(maxHabitNameLength))
        }
        updateCreateButtonState()
    }
    
    private func updateCreateButtonState() {
        let text = nameTextField.text ?? ""
        let isValid = !text.isEmpty && text.count <= maxHabitNameLength
        createButton.isEnabled = isValid
        createButton.backgroundColor = isValid ? Colors.blue : Colors.gray
    }
    
    private func setupTextField() {
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func categoryButtonTapped() {
        // Обработка нажатия категории
    }
    
    @objc private func scheduleButtonTapped() {
        // Обработка нажатия расписания
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        dismiss(animated: true)
    }
}

extension HabitCreationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
