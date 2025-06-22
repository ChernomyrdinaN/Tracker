//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 14.06.2025.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let mainView = UIView()
    private let addButton = UIButton()
    private let dateButton = UIButton()
    private let titleLabel = UILabel()
    private let searchField = UITextField()
    private let errorImageView = UIImageView()
    private let trackLabel = UILabel()
    private let datePicker = UIDatePicker()
    
    // MARK: - Properties
    private var isEmptyState = false {
        didSet {
            // Показываем/скрываем элементы пустого состояния
            errorImageView.isHidden = !isEmptyState
            trackLabel.isHidden = !isEmptyState
        }
    }
    
    private var categories: [TrackerCategory] = [] // Массив категорий трекеров
    private var completedTrackers: [TrackerRecord] = [] // Массив выполненных трекеров
    private var currentDate = Date() // Текущая выбранная дата
    private let defaultCategoryID = UUID() // ID категории по умолчанию
    private let defaultCategoryTitle = "Мои трекеры" // Название категории по умолчанию
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDatePicker()
        setupDateButton()
        setupDefaultCategory()
        checkTrackers()
        setupAddButton()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = Colors.white // Настраиваем цвета
        mainView.backgroundColor = Colors.white
        
        configureAddButton() // Настраиваем отдельные UI-компоненты
        configureTitleLabel()
        configureSearchField()
        configureEmptyState()
        
        addSubviewsAndSetupConstraints() // Добавляем элементы на экран
    }
    
    private func configureAddButton() {
        // Настройка кнопки добавления
        addButton.setImage(UIImage(named: "add_tracker")?.withRenderingMode(.alwaysTemplate), for: .normal)
        addButton.tintColor = Colors.black
    }
    
    private func configureTitleLabel() {
        // Настройка заголовка экрана
        titleLabel.text = "Трекеры"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = Colors.black
    }
    
    private func configureSearchField() {
        // Настройка поля поиска
        searchField.backgroundColor = Colors.searchFieldBackground
        searchField.textColor = Colors.searchTextColor
        searchField.font = .systemFont(ofSize: 17, weight: .regular)
        searchField.layer.cornerRadius = 10
        searchField.layer.masksToBounds = true
        
        // Настройка иконки лупы
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 36))
        let iconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconView.tintColor = Colors.searchTextColor
        iconView.frame = CGRect(x: 8, y: 10, width: 16, height: 16)
        iconContainer.addSubview(iconView)
        
        searchField.leftView = iconContainer
        searchField.leftViewMode = .always
        
        // Настройка placeholder
        searchField.attributedPlaceholder = NSAttributedString(
            string: "Поиск",
            attributes: [
                .foregroundColor: Colors.searchTextColor ?? .lightGray,
                .font: UIFont.systemFont(ofSize: 17, weight: .regular)
            ]
        )
    }
    
    private func configureEmptyState() {
        // Настройка состояния "нет трекеров"
        errorImageView.image = UIImage(named: "ilerror1")
        errorImageView.isHidden = true // По умолчанию скрыто
        
        trackLabel.text = "Что будем отслеживать?"
        trackLabel.font = .systemFont(ofSize: 12, weight: .medium)
        trackLabel.textColor = Colors.black
        trackLabel.textAlignment = .center
        trackLabel.isHidden = true // По умолчанию скрыто
    }
    
    private func addSubviewsAndSetupConstraints() {
        // Добавление всех элементов на view
        [mainView, addButton, dateButton, titleLabel,
         searchField, errorImageView, trackLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        // Установка всех констрейнтов
        NSLayoutConstraint.activate([
            // Основное view занимает весь экран
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Кнопка добавления в левом верхнем углу
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            addButton.widthAnchor.constraint(equalToConstant: 42),
            addButton.heightAnchor.constraint(equalToConstant: 42),
            
            // Кнопка даты справа от кнопки добавления
            dateButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            dateButton.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            dateButton.widthAnchor.constraint(equalToConstant: 77),
            dateButton.heightAnchor.constraint(equalToConstant: 34),
            
            // Заголовок под кнопкой добавления
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 1),
            
            // Поле поиска под заголовком
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            
            // Изображение пустого состояния по центру
            errorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorImageView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 220),
            errorImageView.widthAnchor.constraint(equalToConstant: 80),
            errorImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Текст пустого состояния под изображением
            trackLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 8),
            trackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Date Picker
    private func setupDatePicker() {
        // Настройка пикера даты
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline // Встроенный стиль
        
        // Настройка календаря (русская локаль, понедельник первый день)
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        calendar.locale = Locale(identifier: "ru_RU")
        
        datePicker.calendar = calendar
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.backgroundColor = Colors.white
        datePicker.layer.cornerRadius = 12
        datePicker.isHidden = true
        
        // Ограничение диапазона дат (±10 лет от текущей)
        let currentDate = Date()
        datePicker.minimumDate = calendar.date(byAdding: .year, value: -10, to: currentDate)
        datePicker.maximumDate = calendar.date(byAdding: .year, value: 10, to: currentDate)
        
        // Добавление пикера на view
        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        // Констрейнты для пикера
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: dateButton.bottomAnchor, constant: 8),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.heightAnchor.constraint(equalToConstant: 330)
        ])
    }
    
    private func setupDateButton() {
        // Настройка кнопки даты
        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        updateDateButtonTitle()
        
        // Стиль кнопки
        dateButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        dateButton.setTitleColor(.black, for: .normal)
        dateButton.backgroundColor = Colors.datePickerBackground
        dateButton.layer.cornerRadius = 8
    }
    
    @objc private func dateButtonTapped() {
        // Обработка нажатия на кнопку даты
        datePicker.isHidden = !datePicker.isHidden // Показать/скрыть пикер
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    @objc private func dateChanged() {
        // Обработка изменения даты
        currentDate = datePicker.date
        updateDateButtonTitle()
        datePicker.isHidden = true
    }
    
    private func updateDateButtonTitle() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        formatter.locale = Locale(identifier: "ru_RU")
        dateButton.setTitle(formatter.string(from: currentDate), for: .normal)
    }
    
    // MARK: - Categories Management
    private func setupDefaultCategory() {
        // Создание категории по умолчанию
        let defaultCategory = TrackerCategory(
            id: defaultCategoryID,
            title: defaultCategoryTitle,
            trackers: []
        )
        categories = [defaultCategory]
    }
    
    private func addTrackerToDefaultCategory(_ tracker: Tracker) {
        // Добавление трекера в категорию по умолчанию
        guard let index = categories.firstIndex(where: { $0.id == defaultCategoryID }) else { return }
        let oldCategory = categories[index]
        let updatedCategory = TrackerCategory(
            id: oldCategory.id,
            title: oldCategory.title,
            trackers: oldCategory.trackers + [tracker] // Добавляем новый трекер
        )
        categories[index] = updatedCategory
    }
    
    // MARK: - Tracker Completion
    private func trackerCompleted(_ trackerId: UUID) {
        // Отметить трекер как выполненный
        let record = TrackerRecord(trackerId: trackerId, date: currentDate)
        completedTrackers.append(record)
    }
    
    private func trackerUncompleted(_ trackerId: UUID) {
        // Снять отметку о выполнении
        completedTrackers.removeAll {
            $0.trackerId == trackerId && Calendar.current.isDate($0.date, inSameDayAs: currentDate)
        }
    }
    
    private func isTrackerCompleted(_ trackerId: UUID) -> Bool {
        // Проверить выполнен ли трекер
        completedTrackers.contains {
            $0.trackerId == trackerId && Calendar.current.isDate($0.date, inSameDayAs: currentDate)
        }
    }
    
    // MARK: - Categories Operations
    private func addTracker(_ tracker: Tracker, toCategoryWithId categoryId: UUID) {
        // Добавление трекера в категорию
        if let index = categories.firstIndex(where: { $0.id == categoryId }) {
            // Если категория существует - обновляем
            let oldCategory = categories[index]
            let updatedCategory = TrackerCategory(
                id: oldCategory.id,
                title: oldCategory.title,
                trackers: oldCategory.trackers + [tracker]
            )
            categories[index] = updatedCategory
        } else {
            // Если нет - создаем новую
            categories.append(makeNewCategory(with: tracker, id: categoryId))
        }
    }
    
    private func makeNewCategory(with tracker: Tracker, id: UUID) -> TrackerCategory {
        // Создание новой категории
        return TrackerCategory(
            id: id,
            title: "Новая категория",
            trackers: [tracker]
        )
    }
    
    private func updateCategoryTitle(_ newTitle: String, forCategoryId categoryId: UUID) {
        // Обновление названия категории
        guard let index = categories.firstIndex(where: { $0.id == categoryId }) else { return }
        let oldCategory = categories[index]
        let updatedCategory = TrackerCategory(
            id: oldCategory.id,
            title: newTitle,  // Новое название
            trackers: oldCategory.trackers  // Старые трекеры
        )
        categories[index] = updatedCategory
    }
    
    // MARK: - Helpers
    private func checkTrackers() {
        // Проверка на пустое состояние
        isEmptyState = categories.flatMap { $0.trackers }.isEmpty
    }
    
    // MARK: - Actions
    private func setupAddButton() {
        // Настройка действия кнопки добавления
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addButtonTapped() {
        // Открытие экрана создания привычки
        let habitVC = HabitCreationViewController()
        let navController = UINavigationController(rootViewController: habitVC)
        present(navController, animated: true)
    }
}
