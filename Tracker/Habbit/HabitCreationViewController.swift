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
    private let inputContainer = UIView()
    private let nameTextField = UITextField()
    private let clearTextFieldButton = UIButton(type: .system)
    private let errorLabel = UILabel()
    private let categoryButton = UIButton()
    private let scheduleButton = UIButton()
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    private let keyboardHandler = KeyboardHandler()
    
    private let scheduleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Расписание"
        label.textColor = Colors.black
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private let scheduleValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.gray
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private let scheduleStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 2
        return stack
    }()
    
    // MARK: - Properties
    private let maxHabitNameLength = 38
    private var selectedSchedule: Set<WeekDay> = []
    var onTrackerCreated: ((Tracker) -> Void)?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        keyboardHandler.setup(for: self)
        nameTextField.delegate = keyboardHandler
        updateCategoryButtonTitle()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = Colors.white
        configureTitleLabel()
        configureInputContainer()
        configureCategoryButton()
        configureScheduleButton()
        configureCancelButton()
        configureCreateButton()
        addSubviews()
    }
    
    // MARK: - Private Methods
    
    private func configureTitleLabel() {
        titleLabel.text = "Новая привычка"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = Colors.black
        titleLabel.textAlignment = .center
    }
    
    private func configureInputContainer() {
        inputContainer.backgroundColor = .clear
        [nameTextField, clearTextFieldButton, errorLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            inputContainer.addSubview($0)
        }
        
        configureNameTextField()
        configureClearButton()
        configureErrorLabel()
    }
    
    private func configureNameTextField() {
        nameTextField.placeholder = "Введите название трекера"
        nameTextField.backgroundColor = Colors.background
        nameTextField.font = .systemFont(ofSize: 17, weight: .regular)
        nameTextField.textColor = Colors.black
        nameTextField.layer.cornerRadius = 16
        nameTextField.layer.masksToBounds = true
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        nameTextField.leftViewMode = .always
        nameTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 41, height: 75))
        nameTextField.rightViewMode = .always
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func configureClearButton() {
        clearTextFieldButton.setImage(UIImage(named: "xmark_circle"), for: .normal)
        clearTextFieldButton.tintColor = Colors.gray
        clearTextFieldButton.isHidden = true
        clearTextFieldButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
    }
    
    private func configureErrorLabel() {
        errorLabel.text = "Ограничение 38 символов"
        errorLabel.font = .systemFont(ofSize: 17, weight: .regular)
        errorLabel.textColor = Colors.red
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true
    }
    
    private func configureCategoryButton() {
        setupButton(categoryButton, title: "Категория", isFirst: true)
        categoryButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
    }
    
    private func configureScheduleButton() {
        let container = UIView()
        container.isUserInteractionEnabled = false
        
        scheduleStackView.addArrangedSubview(scheduleLabel)
        scheduleStackView.addArrangedSubview(scheduleValueLabel)
        container.addSubview(scheduleStackView)
        
        let arrow = UIImageView(image: UIImage(named: "chevron"))
        arrow.tintColor = Colors.gray
        
        container.addSubview(arrow)
        
        scheduleStackView.translatesAutoresizingMaskIntoConstraints = false
        arrow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scheduleStackView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            scheduleStackView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            arrow.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            arrow.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            arrow.leadingAnchor.constraint(equalTo: scheduleStackView.trailingAnchor, constant: -32)
        ])
        
        scheduleButton.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: scheduleButton.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: scheduleButton.trailingAnchor, constant: -16),
            container.centerYAnchor.constraint(equalTo: scheduleButton.centerYAnchor),
            container.heightAnchor.constraint(equalTo: scheduleButton.heightAnchor)
        ])
        
        scheduleButton.backgroundColor = Colors.background
        scheduleButton.layer.cornerRadius = 16
        scheduleButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        scheduleButton.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)
    }
    
    private func configureCancelButton() {
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.backgroundColor = .clear
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cancelButton.setTitleColor(Colors.red, for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = Colors.red?.cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    private func configureCreateButton() {
        createButton.setTitle("Создать", for: .normal)
        
        createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        createButton.setTitleColor(Colors.white, for: .normal)
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
        
        createButton.backgroundColor = Colors.gray
        createButton.setBackgroundColor(Colors.black ?? .black,for: .normal)
        createButton.setBackgroundColor(Colors.black ?? .black,for: .highlighted)
        
        createButton.isEnabled = false
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    
    private func setupButton(_ button: UIButton, title: String, isFirst: Bool) {
        let container = UIView()
        container.isUserInteractionEnabled = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = Colors.black
        titleLabel.tag = 100
        
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
            arrow.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -32)
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
    
    private func updateCategoryButtonTitle() {
        guard let container = categoryButton.subviews.first,
              let titleLabel = container.viewWithTag(100) as? UILabel else {
            return
        }
        titleLabel.text = "Категория"
    }
    
    private func updateScheduleButtonTitle() {
        if selectedSchedule.isEmpty {
            scheduleValueLabel.text = nil
        } else if selectedSchedule.count == WeekDay.allCases.count {
            scheduleValueLabel.text = "Каждый день"
        } else {
            let shortNames = selectedSchedule.sorted(by: { $0.calendarIndex < $1.calendarIndex }).map { $0.shortName }
            scheduleValueLabel.text = shortNames.joined(separator: ", ")
        }
    }
    
    // MARK: Data Handling
    private func addSubviews() {
        [titleLabel, inputContainer, categoryButton, scheduleButton, cancelButton, createButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            inputContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            inputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            inputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            inputContainer.heightAnchor.constraint(equalToConstant: 75 + 30),
            
            nameTextField.topAnchor.constraint(equalTo: inputContainer.topAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            clearTextFieldButton.centerYAnchor.constraint(equalTo: nameTextField.centerYAnchor),
            clearTextFieldButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor, constant: -16),
            clearTextFieldButton.widthAnchor.constraint(equalToConstant: 17),
            clearTextFieldButton.heightAnchor.constraint(equalToConstant: 17),
            
            errorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            errorLabel.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -16),
            
            categoryButton.topAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: 24),
            categoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            
            scheduleButton.topAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            scheduleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleButton.heightAnchor.constraint(equalToConstant: 75),
            
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
    
    private func updateCreateButtonState() {
        let text = nameTextField.text ?? ""
        let isValid = !text.isEmpty && text.count <= maxHabitNameLength
        createButton.isEnabled = isValid
        createButton.backgroundColor = isValid ? Colors.blue : Colors.gray
    }
    
    private func resetErrorState() {
        errorLabel.isHidden = true
        view.constraints.first {
            $0.firstItem as? UIButton == categoryButton && $0.firstAttribute == .top
        }?.constant = 24
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Actions
    @objc private func clearTextField() {
        nameTextField.text = ""
        clearTextFieldButton.isHidden = true
        resetErrorState()
        updateCreateButtonState()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        let isErrorVisible = text.count > maxHabitNameLength
        errorLabel.isHidden = !isErrorVisible
        clearTextFieldButton.isHidden = text.isEmpty
        
        view.constraints.first {
            $0.firstItem as? UIButton == categoryButton && $0.firstAttribute == .top
        }?.constant = isErrorVisible ? 32 : 24
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        if isErrorVisible {
            textField.text = String(text.prefix(maxHabitNameLength))
        }
        updateCreateButtonState()
    }
    
    @objc private func createButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        
        let newTracker = Tracker(
            id: UUID(),
            name: name,
            color: "Color selection 12",
            emoji: "👩🏻",
            schedule: Array(selectedSchedule),
            isRegular: !selectedSchedule.isEmpty,
            colorAssetName: "Color selection 12"
        )
        
        onTrackerCreated?(newTracker)
        dismiss(animated: true)
    }
    
    @objc private func categoryButtonTapped() {
        let alert = UIAlertController(
            title: "Выбор категории",
            message: "Функционал выбора категории будет добавлен после подключения базы данных",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func scheduleButtonTapped() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.selectedDays = selectedSchedule
        scheduleVC.onScheduleSelected = { [weak self] days in
            self?.selectedSchedule = days
            self?.updateScheduleButtonTitle()
        }
        let navVC = UINavigationController(rootViewController: scheduleVC)
        present(navVC, animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        let image = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { context in
            color.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
        setBackgroundImage(image, for: state)
    }
}
