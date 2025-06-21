//
//  HabitCreationViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 19.06.2025.
//

import UIKit

final class HabitCreationViewController: UIViewController {
    
    // MARK: - UI Elements
    private let mainView = UIView()
    private let titleLabel = UILabel()
    private let nameTextField = UITextField()
    private let clearTextFieldButton = UIButton(type: .system)
    private let errorLabel = UILabel()
    private let tableView = UITableView()
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    
    private let options = ["Категория", "Расписание"]
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
        view.backgroundColor = Colors.whiteNight
        mainView.backgroundColor = Colors.whiteDay
        
        // Настройка заголовка
        titleLabel.text = "Новая привычка"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = Colors.blackDay
        titleLabel.textAlignment = .center
        
        // Настройка поля ввода
        nameTextField.placeholder = "Введите название трекера"
        nameTextField.backgroundColor = Colors.backgroundDay
        nameTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        nameTextField.textColor = Colors.blackDay
        nameTextField.layer.cornerRadius = 16
        nameTextField.layer.masksToBounds = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        nameTextField.leftView = paddingView
        nameTextField.leftViewMode = .always
        
        // Кнопка очистки текста (крестик)
        clearTextFieldButton.setImage(UIImage(named: "xmark_circle"), for: .normal)
        clearTextFieldButton.tintColor = Colors.gray
        clearTextFieldButton.isHidden = true
        clearTextFieldButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        
        
        // Лейбл ошибки
        errorLabel.text = "Ограничение 38 символов"
        errorLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        errorLabel.textColor = Colors.red
        errorLabel.isHidden = true
        
        // Настройка таблицы
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        // Настройка кнопки "Отменить"
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.backgroundColor = .clear
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.setTitleColor(Colors.red, for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = Colors.red?.cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        // Настройка кнопки "Создать"
        createButton.setTitle("Создать", for: .normal)
        createButton.backgroundColor = Colors.gray
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.setTitleColor(Colors.whiteDay, for: .normal)
        createButton.isEnabled = false
        createButton.layer.cornerRadius = 16
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        [mainView, titleLabel, nameTextField, clearTextFieldButton, errorLabel, tableView, cancelButton, createButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Основное вью
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Заголовок
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Поле ввода
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            // Кнопка очистки текста
            clearTextFieldButton.centerYAnchor.constraint(equalTo: nameTextField.centerYAnchor),
            clearTextFieldButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor, constant: -16),
            clearTextFieldButton.widthAnchor.constraint(equalToConstant: 20),
            clearTextFieldButton.heightAnchor.constraint(equalToConstant: 20),
            
            // Лейбл ошибки
            errorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            errorLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor, constant: 16),
            
            // Таблица с кнопками
            tableView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            
            // Кнопка отмены
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cancelButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Кнопка создания
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
        
        // Показываем/скрываем крестик
        clearTextFieldButton.isHidden = text.isEmpty
        
        // Проверяем длину текста
        errorLabel.isHidden = text.count <= 38
        updateCreateButtonState()
        
        // Автоматическая обрезка если превышен лимит
        if text.count > 38 {
            textField.text = String(text.prefix(38))
            errorLabel.isHidden = false
        }
        
        // Обновляем состояние кнопки "Создать"
        updateCreateButtonState()
    }
    
    private func updateCreateButtonState() {
        let text = nameTextField.text ?? ""
        let isNameValid = !text.isEmpty && text.count <= maxHabitNameLength
        createButton.isEnabled = isNameValid
        createButton.backgroundColor = isNameValid ? Colors.blue : Colors.gray
    }
    
    private func setupTextField() {
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension HabitCreationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true // Разрешаем все изменения текста поверку длины будем делать в textFieldDidChange
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension HabitCreationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        cell.backgroundColor = Colors.backgroundDay
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Обработка выбора категории или расписания
    }
}
