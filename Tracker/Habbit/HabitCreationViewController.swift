//
//  HabitCreationViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 19.06.2025.
//

import UIKit

final class HabitCreationViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = Colors.black
        label.textAlignment = .center
        return label
    }()
    
    private let inputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let nameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Введите название трекера"
        field.backgroundColor = Colors.background
        field.font = .systemFont(ofSize: 17, weight: .regular)
        field.textColor = Colors.black
        field.layer.cornerRadius = 16
        field.layer.masksToBounds = true
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        field.leftViewMode = .always
        field.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 41, height: 75))
        field.rightViewMode = .always
        return field
    }()
    
    private let clearTextFieldButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "xmark_circle"), for: .normal)
        button.tintColor = Colors.gray
        button.isHidden = true
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = Colors.red
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton()
        setupButton(button, title: "Категория", isFirst: true)
        return button
    }()
    
    private lazy var scheduleButton: UIButton = {
        let button = UIButton()
        
        let container = UIView()
        container.isUserInteractionEnabled = false
        
        let scheduleLabel = UILabel()
        scheduleLabel.text = "Расписание"
        scheduleLabel.textColor = Colors.black
        scheduleLabel.font = .systemFont(ofSize: 17)
        
        let scheduleValueLabel = UILabel()
        scheduleValueLabel.textColor = Colors.gray
        scheduleValueLabel.font = .systemFont(ofSize: 17)
        
        let stack = UIStackView(arrangedSubviews: [scheduleLabel, scheduleValueLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 2
        
        let arrow = UIImageView(image: UIImage(named: "chevron"))
        arrow.tintColor = Colors.gray
        
        container.addSubview(stack)
        container.addSubview(arrow)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        arrow.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            arrow.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            arrow.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            arrow.leadingAnchor.constraint(equalTo: stack.trailingAnchor, constant: -32)
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
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(Colors.red, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = Colors.red?.cgColor
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(Colors.white, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.setBackgroundColor(Colors.black ?? .black, for: .normal)
        button.setBackgroundColor(Colors.black ?? .black, for: .highlighted)
        button.isEnabled = false
        return button
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    // MARK: - Properties
    private let maxHabitNameLength = 38
    private var selectedSchedule: Set<WeekDay> = []
    private let keyboardHandler = KeyboardHandler()
    var onTrackerCreated: ((Tracker) -> Void)?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        setupViews()
        setupConstraints()
        setupActions()
        
        keyboardHandler.setup(for: self)
        nameTextField.delegate = keyboardHandler
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        [titleLabel, inputContainer, categoryButton, scheduleButton, buttonsStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        [nameTextField, clearTextFieldButton, errorLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            inputContainer.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            inputContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            inputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            inputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            inputContainer.heightAnchor.constraint(equalToConstant: 75),
            
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
            
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonsStack.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupActions() {
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        clearTextFieldButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        categoryButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        scheduleButton.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
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
    
    private func updateScheduleButtonTitle() {
        guard let stack = scheduleButton.subviews.first?.subviews.first as? UIStackView,
              let valueLabel = stack.arrangedSubviews.last as? UILabel else { return }
        
        if selectedSchedule.isEmpty {
            valueLabel.text = nil
        } else if selectedSchedule.count == WeekDay.allCases.count {
            valueLabel.text = "Каждый день"
        } else {
            let shortNames = selectedSchedule.sorted(by: { $0.calendarIndex < $1.calendarIndex }).map { $0.shortName }
            valueLabel.text = shortNames.joined(separator: ", ")
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
        }?.constant = isErrorVisible ? 56 : 24
        
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
            emoji: "👩🏽‍💻",
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
