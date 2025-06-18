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
    private var isEmptyState = false {
        didSet {
            errorImageView.isHidden = !isEmptyState
            trackLabel.isHidden = !isEmptyState
        }
    }
    
    private var categories: [TrackerCategory] = []  // Храним категории с трекерами
    private var completedTrackers: [TrackerRecord] = [] // Храним выполненные трекеры
    private var currentDate = Date() // Текущая выбранная дата
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkTrackers()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = Colors.whiteNight
        
        mainView.backgroundColor = Colors.whiteNight
        
        addButton.setImage(UIImage(named: "add_tracker"), for: .normal)
        addButton.tintColor = Colors.blackNight
        
        dateButton.setTitle("14.12.22", for: .normal)
        dateButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        dateButton.setTitleColor(Colors.blackDay, for: .normal)
        dateButton.backgroundColor = Colors.datePickerBackground
        dateButton.layer.cornerRadius = 8
        
        titleLabel.text = "Трекеры"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = Colors.blackNight
        
        searchField.backgroundColor = Colors.searchFieldBackground
        searchField.textColor = Colors.searchTextColor
        searchField.font = .systemFont(ofSize: 17, weight: .regular)
        searchField.layer.cornerRadius = 10
        searchField.layer.masksToBounds = true
        
        let iconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconView.tintColor = Colors.searchTextColor
        searchField.leftView = iconView
        searchField.leftViewMode = .always
        
        searchField.attributedPlaceholder = NSAttributedString(
            string: "Поиск",
            attributes: [
                .foregroundColor: Colors.searchTextColor ?? .lightGray,
                .font: UIFont.systemFont(ofSize: 17, weight: .regular)
            ]
        )
        
        errorImageView.image = UIImage(named: "ilerror1")
        errorImageView.isHidden = true
        
        trackLabel.text = "Что будем отслеживать?"
        trackLabel.font = .systemFont(ofSize: 12, weight: .medium)
        trackLabel.textColor = Colors.blackNight
        trackLabel.textAlignment = .center
        trackLabel.isHidden = true
        
        [mainView, addButton, dateButton, titleLabel,
         searchField, errorImageView, trackLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Main View
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Add Button
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            addButton.widthAnchor.constraint(equalToConstant: 42),
            addButton.heightAnchor.constraint(equalToConstant: 42),
            
            // Date Button
            dateButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            dateButton.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            dateButton.widthAnchor.constraint(equalToConstant: 77),
            dateButton.heightAnchor.constraint(equalToConstant: 34),
            
            // Title Label
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 1),
            
            // Search Field
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            
            // Error Image
            errorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorImageView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 220),
            errorImageView.widthAnchor.constraint(equalToConstant: 80),
            errorImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Track Label
            trackLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 8),
            trackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func checkTrackers() {
        // Пока отсутствует логика можно проверить так:
        let testTrackers: [String] = [] // заглушка появится
        //let testTrackers = ["Трекер 1", "Трекер 2"] // заглушка исчезнет
        isEmptyState = testTrackers.isEmpty
    }
    
    // MARK: - Работа с выполнением трекеров
       private func trackerCompleted(_ trackerId: UUID) {  // Добавляем запись о выполнении
           let record = TrackerRecord(trackerId: trackerId, date: currentDate)
           completedTrackers.append(record)
       }
       
       private func trackerUncompleted(_ trackerId: UUID) { // Удаляем запись, отмена выполнения трекера
           completedTrackers.removeAll { $0.trackerId == trackerId && Calendar.current.isDate($0.date, inSameDayAs: currentDate) }
       }
      
       private func isTrackerCompleted(_ trackerId: UUID) -> Bool { // Проверяем выполнен ли трекер сегодня
           completedTrackers.contains { $0.trackerId == trackerId && Calendar.current.isDate($0.date, inSameDayAs: currentDate) }
       }
       
       // MARK: - Работа с категориями
       private func addTracker(_ tracker: Tracker, toCategoryWithId categoryId: UUID) { // Добавляем новый трекер в категорию
           var newCategories = categories.map { category in
               if category.id == categoryId {
                   var newTrackers = category.trackers
                   newTrackers.append(tracker)
                   return TrackerCategory(
                       id: category.id,
                       title: category.title,
                       trackers: newTrackers
                   )
               }
               return category
           }
           
           if !newCategories.contains(where: { $0.id == categoryId }) { // если категории с таким id нет, создаем новую
               let newCategory = TrackerCategory(
                   id: categoryId,
                   title: "Новая категория",
                   trackers: [tracker]
               )
               newCategories.append(newCategory)
           }
           
           categories = newCategories
       }
    
       private func updateCategoryTitle(_ newTitle: String, forCategoryId categoryId: UUID) { // Меняем название категории
           categories = categories.map { category in
               if category.id == categoryId {
                   return TrackerCategory(
                       id: category.id,
                       title: newTitle,
                       trackers: category.trackers
                   )
               }
               return category
           }
       }
   }
