//
//  HabitCreationViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 19.06.2025.
//
import UIKit

class HabitCreationViewController: UIViewController {
    // MARK: - Properties
        var selectedCategory: TrackerCategory?
        var selectedEmoji: String?
        var selectedColor: UIColor?
        var selectedSchedule: Set<WeekDay> = []
        var onTrackerCreated: ((Tracker) -> Void)?
        
        private let keyboardHandler = KeyboardHandler()
        private let trackerStore = TrackerStore()
        
        // MARK: - UI Elements
        lazy var titleLabel = makeTitleLabel()
        lazy var nameTextField = makeNameTextField()
        lazy var emojiCollectionView = EmojiCollectionView()
        lazy var colorCollectionView = ColorCollectionView()
        lazy var createButton = makeCreateButton()
        
        private lazy var errorLabel = makeErrorLabel()
        private lazy var categoryButton = makeCategoryButton()
        private lazy var scheduleButton = makeScheduleButton()
        private lazy var cancelButton = makeCancelButton()
        private lazy var buttonsStack = makeButtonsStack()
        private lazy var scrollView = makeScrollView()
        private lazy var contentView = makeContentView()
        private lazy var emojiLabel = makeEmojiLabel()
        private lazy var colorLabel = makeColorLabel()
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        setupUI()
        setupActions()
        setupDelegates()
    }
        
    // MARK: - Update Methods
    func updateCreateButtonState() {
        let isFormValid = !(nameTextField.text?.isEmpty ?? true)
        && (nameTextField.text?.count ?? 0) <= Constants.maxHabitNameLength
        && selectedCategory != nil
        && !selectedSchedule.isEmpty
        && selectedEmoji != nil
        && selectedColor != nil
        
        createButton.isEnabled = isFormValid
        createButton.backgroundColor = isFormValid ? Colors.black : Colors.gray
    }
    
    func updateScheduleButtonTitle() {
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
    
    func updateCategoryButtonTitle() {
        guard let container = categoryButton.subviews.first,
              let stack = container.subviews.first as? UIStackView,
              stack.arrangedSubviews.count > 1,
              let valueLabel = stack.arrangedSubviews[1] as? UILabel else { return }
        
        valueLabel.text = selectedCategory?.title
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        [titleLabel, scrollView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        scrollView.addSubview(contentView)
        
        [nameTextField, errorLabel, categoryButton, scheduleButton,
            emojiLabel, emojiCollectionView, colorLabel, colorCollectionView,
            buttonsStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            errorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            categoryButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            categoryButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            
            scheduleButton.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 0),
            scheduleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            scheduleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            scheduleButton.heightAnchor.constraint(equalToConstant: 75),
            
            emojiLabel.topAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: 50),
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 16),
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 204),
            
            colorLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 34),
            colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            colorCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 16),
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 204),
            
            buttonsStack.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
            buttonsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            buttonsStack.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupDelegates() {
        keyboardHandler.setup(for: self)
        nameTextField.delegate = keyboardHandler
        
        emojiCollectionView.onEmojiSelected = { [weak self] emoji in
            self?.selectedEmoji = emoji
            self?.updateCreateButtonState()
        }
        
        colorCollectionView.didSelectColor = { [weak self] color in
            self?.selectedColor = color
            self?.updateCreateButtonState()
        }
    }
    
    private func setupActions() {
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        categoryButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        scheduleButton.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - UI Factory Methods
    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = "Новая привычка"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = Colors.black
        label.textAlignment = .center
        return label
    }
    
    private func makeNameTextField() -> UITextField {
        let field = UITextField()
        field.placeholder = "Введите название трекера"
        field.backgroundColor = Colors.background
        field.font = .systemFont(ofSize: 17, weight: .regular)
        field.tintColor = Colors.black
        field.layer.cornerRadius = 16
        field.layer.masksToBounds = true
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 75))
        field.leftViewMode = .always
        field.clearButtonMode = .whileEditing
        return field
    }
    
    private func makeErrorLabel() -> UILabel {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = Colors.red
        label.textAlignment = .center
        label.isHidden = true
        return label
    }
    
    private func makeCategoryButton() -> UIButton {
        let button = UIButton()
        configureButton(button, title: "Категория", isFirst: true)
        return button
    }
    
    private func makeScheduleButton() -> UIButton {
        let button = UIButton()
        configureButton(button, title: "Расписание", isFirst: false)
        return button
    }
    
    private func configureButton(_ button: UIButton, title: String, isFirst: Bool) {
        let container = UIView()
        container.isUserInteractionEnabled = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = Colors.black
        titleLabel.tag = 100
        
        let valueLabel = UILabel()
        valueLabel.font = .systemFont(ofSize: 17, weight: .regular)
        valueLabel.textColor = Colors.gray
        valueLabel.tag = 101
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 2
        
        let arrow = UIImageView(image: UIImage(resource: .chevron))
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
    
    private func makeCancelButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(Colors.red, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = Colors.red.cgColor
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }
    
    private func makeCreateButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(Colors.white, for: .normal)
        button.backgroundColor = Colors.gray
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.isEnabled = false
        return button
    }
    
    private func makeButtonsStack() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }
    
    private func makeScrollView() -> UIScrollView {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }
    
    private func makeContentView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func makeEmojiLabel() -> UILabel {
        let label = UILabel()
        label.text = "Emoji"
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = Colors.black
        return label
    }
    
    private func makeColorLabel() -> UILabel {
        let label = UILabel()
        label.text = "Цвет"
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = Colors.black
        return label
    }
    
    // MARK: - Actions
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        let isErrorVisible = text.count > Constants.maxHabitNameLength
        
        errorLabel.isHidden = !isErrorVisible
        contentView.constraints
            .first { $0.firstItem as? UIButton == categoryButton && $0.firstAttribute == .top }?
            .constant = isErrorVisible ? 56 : 24
        
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
        
        if isErrorVisible {
            textField.text = String(text.prefix(Constants.maxHabitNameLength))
        }
        updateCreateButtonState()
    }
    
    @objc dynamic func createButtonTapped() {
            guard let name = nameTextField.text,
                  let selectedCategory = selectedCategory else { return }
            
            let newTracker = Tracker(
                id: UUID(),
                name: name,
                color: Colors.colorName(for: selectedColor!) ?? "Color selection 1",
                emoji: selectedEmoji!,
                schedule: Array(selectedSchedule),
                colorAssetName: Colors.colorName(for: selectedColor!) ?? "Color selection 1"
            )
            
            do {
                try trackerStore.addTracker(newTracker, to: selectedCategory)
                dismiss(animated: true)
            } catch {
                print("Ошибка при создании трекера: \(error.localizedDescription)")
            }
        }
        
    @objc private func categoryButtonTapped() {
        let categoriesViewModel = CategoriesViewModel()
        
        if let selectedCategory = selectedCategory {
            categoriesViewModel.selectCategory(with: selectedCategory.title)
        }
        
        let categoryVC = CategorySelectionViewController(viewModel: categoriesViewModel)
        
        categoryVC.onCategorySelected = { [weak self] (category: TrackerCategory) in
            self?.selectedCategory = category
            self?.updateCategoryButtonTitle()
            self?.updateCreateButtonState()
        }
        
        let navVC = UINavigationController(rootViewController: categoryVC)
        present(navVC, animated: true)
    }
    
    @objc private func scheduleButtonTapped() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.selectedDays = selectedSchedule
        scheduleVC.onScheduleSelected = { [weak self] days in
            self?.selectedSchedule = days
            self?.updateScheduleButtonTitle()
            self?.updateCreateButtonState()
        }
        let navVC = UINavigationController(rootViewController: scheduleVC)
        present(navVC, animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - Extensions
extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        let image = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { context in
            color.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
        setBackgroundImage(image, for: state)
    }
}

extension Colors {
    static func colorName(for color: UIColor) -> String? {
        trackerColors.firstIndex { $0.isEqual(color) }.map { "Color selection \($0 + 1)" }
    }
}
