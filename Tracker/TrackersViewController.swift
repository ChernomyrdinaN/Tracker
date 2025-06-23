//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 14.06.2025.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let searchField = UITextField()
    private let errorImageView = UIImageView()
    private let trackLabel = UILabel()
    private let datePicker = UIDatePicker()
    
    // MARK: - Properties
    private var isEmptyState = false {
        didSet {
            errorImageView.isHidden = !isEmptyState
            trackLabel.isHidden = !isEmptyState
        }
    }
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var currentDate = Date()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupDefaultCategory()
        checkTrackers()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = Colors.white
        
        configureTitleLabel()
        configureSearchField()
        configureEmptyState()
        
        addSubviewsAndSetupConstraints()
    }
    
    // MARK: - Navigation Bar Setup
    private func setupNavigationBar() {
        // Настройка кнопки добавления (+)
        let addButton = UIBarButtonItem(
            image: UIImage(named: "add_tracker")?.withRenderingMode(.alwaysTemplate),
            style: .plain,
            target: self,
            action: #selector(addButtonTapped))
        addButton.tintColor = Colors.black
        navigationItem.leftBarButtonItem = addButton
        
        // Настройка datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    // MARK: - UI Configuration
    private func configureTitleLabel() {
        titleLabel.text = "Трекеры"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = Colors.black
    }
    
    private func configureSearchField() {
        searchField.backgroundColor = Colors.searchFieldBackground
        searchField.textColor = Colors.searchTextColor
        searchField.font = .systemFont(ofSize: 17, weight: .regular)
        searchField.layer.cornerRadius = 10
        searchField.layer.masksToBounds = true
        
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 36))
        let iconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconView.frame = CGRect(x: 8, y: 10, width: 16, height: 16)
        iconView.tintColor = Colors.searchTextColor
        iconContainer.addSubview(iconView)
        
        searchField.leftView = iconContainer
        searchField.leftViewMode = .always
        searchField.placeholder = "Поиск"
    }
    
    private func configureEmptyState() {
        errorImageView.image = UIImage(named: "ilerror1")
        errorImageView.isHidden = true
        trackLabel.text = "Что будем отслеживать?"
        trackLabel.font = .systemFont(ofSize: 12, weight: .medium)
        trackLabel.textColor = Colors.black
        trackLabel.isHidden = true
    }
    
    // MARK: - Constraints (без изменений)
    private func addSubviewsAndSetupConstraints() {
        [titleLabel, searchField, errorImageView, trackLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            
            errorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorImageView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 220),
            errorImageView.widthAnchor.constraint(equalToConstant: 80),
            errorImageView.heightAnchor.constraint(equalToConstant: 80),
            
            trackLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 8),
            trackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        let habitVC = HabitCreationViewController()
        let navController = UINavigationController(rootViewController: habitVC)
        present(navController, animated: true)
    }
    
    // MARK: - Data Management
    private func setupDefaultCategory() {
        let defaultCategory = TrackerCategory(
            id: UUID(),
            title: "Мои трекеры",
            trackers: []
        )
        categories = [defaultCategory]
    }
    
    private func checkTrackers() {
        isEmptyState = categories.flatMap { $0.trackers }.isEmpty
    }
}
