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
    private let keyboardHandler = KeyboardHandler()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TrackerCell.self, forCellWithReuseIdentifier: "TrackerCell")
        collection.register(
            TrackerSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
        collection.backgroundColor = .clear
        return collection
    }()
    
    // MARK: - Properties
    private var isEmptyState = false {
        didSet {
            updateEmptyStateVisibility()
        }
    }
    
    private var currentDate = Date() {
        didSet {
            reloadCollectionView()
            updateEmptyState()
        }
    }
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    private var filteredCategories: [TrackerCategory] {
        categories.map { category in
            let filteredTrackers = category.trackers.filter { isTrackerVisible($0, for: currentDate) }
            return TrackerCategory(id: category.id, title: category.title, trackers: filteredTrackers)
        }.filter { !$0.trackers.isEmpty }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupNavigationBar()
        updateEmptyStateWithDelay()
        keyboardHandler.setup(for: self)
        searchField.delegate = keyboardHandler
    }
    
    // MARK: - Configuration
    private func setupUI() {
        view.backgroundColor = Colors.white
        
        configureTitleLabel()
        configureSearchField()
        configureErrorImageView()
        configureTrackLabel()
        configureDatePicker()
        
        [titleLabel, searchField, errorImageView, trackLabel, collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func configureTitleLabel() {
        titleLabel.text = "Трекеры"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = Colors.black
    }
    
    private func configureSearchField() {
        searchField.backgroundColor = Colors.searchFieldBackground
        searchField.font = .systemFont(ofSize: 17)
        searchField.textColor = Colors.searchTextColor
        searchField.layer.cornerRadius = 10
        searchField.layer.masksToBounds = true
        searchField.placeholder = "Поиск"
        
        let iconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconView.tintColor = Colors.gray
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 36))
        iconView.frame = CGRect(x: 8, y: 10, width: 16, height: 16)
        container.addSubview(iconView)
        
        searchField.leftView = container
        searchField.leftViewMode = .always
    }
    
    private func configureErrorImageView() {
        errorImageView.image = UIImage(named: "ilerror1")
        errorImageView.contentMode = .scaleAspectFit
        errorImageView.isHidden = true
    }
    
    private func configureTrackLabel() {
        trackLabel.text = "Что будем отслеживать?"
        trackLabel.font = .systemFont(ofSize: 12, weight: .medium)
        trackLabel.textColor = Colors.black
        trackLabel.isHidden = true
    }
    
    private func configureDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
        addButton.tintColor = Colors.black
        navigationItem.leftBarButtonItem = addButton
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            
            errorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorImageView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 230),
            errorImageView.widthAnchor.constraint(equalToConstant: 80),
            errorImageView.heightAnchor.constraint(equalToConstant: 80),
            
            trackLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 8),
            trackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Private Methods
    private func updateEmptyStateWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateEmptyState()
        }
    }
    
    private func updateEmptyState() {
        isEmptyState = filteredCategories.isEmpty
    }
    
    private func updateEmptyStateVisibility() {
        errorImageView.isHidden = !isEmptyState
        trackLabel.isHidden = !isEmptyState
        collectionView.isHidden = isEmptyState
    }
    
    private func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func isTrackerVisible(_ tracker: Tracker, for date: Date) -> Bool {
        guard tracker.isRegular else { return true }
        
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        
        return tracker.schedule?.contains { $0.calendarIndex == weekday } ?? false
    }
    
    private func isTrackerCompletedToday(_ trackerId: UUID) -> Bool {
        completedTrackers.contains { record in
            record.trackerId == trackerId && Calendar.current.isDate(record.date, inSameDayAs: currentDate)
        }
    }
    
    private func handleTrackerCompletion(trackerId: UUID, date: Date, isCompleted: Bool) {
        if isCompleted {
            completedTrackers.append(TrackerRecord(trackerId: trackerId, date: date))
        } else {
            completedTrackers.removeAll { $0.trackerId == trackerId && Calendar.current.isDate($0.date, inSameDayAs: date) }
        }
        
        if let indexPath = indexPathForTracker(with: trackerId) {
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    private func indexPathForTracker(with id: UUID) -> IndexPath? {
        for (section, category) in filteredCategories.enumerated() {
            if let row = category.trackers.firstIndex(where: { $0.id == id }) {
                return IndexPath(row: row, section: section)
            }
        }
        return nil
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        let habitVC = HabitCreationViewController()
        habitVC.modalPresentationStyle = .formSheet
        
        habitVC.onTrackerCreated = { [weak self] newTracker in
            guard let self = self else { return }
            
            if let firstCategoryIndex = self.categories.firstIndex(where: { $0.title == "Образование" }) {
                self.categories[firstCategoryIndex].trackers.append(newTracker)
            } else {
                let newCategory = TrackerCategory(
                    id: UUID(),
                    title: "Образование",
                    trackers: [newTracker]
                )
                self.categories.append(newCategory)
            }
            
            self.reloadCollectionView()
            self.updateEmptyState()
        }
        
        let navController = UINavigationController(rootViewController: habitVC)
        present(navController, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "TrackerCell",
            for: indexPath
        ) as? TrackerCell else {
            fatalError("Could not dequeue TrackerCell")
        }
        
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
        let completedDays = completedTrackers.filter { $0.trackerId == tracker.id }.count
        let isCompletedToday = isTrackerCompletedToday(tracker.id)
        
        cell.configure(
            with: tracker,
            completedDays: completedDays,
            isCompletedToday: isCompletedToday,
            currentDate: currentDate
        )
        
        cell.onPlusButtonTapped = { [weak self] trackerId, date, isCompleted in
            self?.handleTrackerCompletion(trackerId: trackerId, date: date, isCompleted: isCompleted)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "header",
                for: indexPath
              ) as? TrackerSectionHeader else {
            fatalError("Could not dequeue TrackerSectionHeader")
        }
        
        header.titleLabel.text = filteredCategories[indexPath.section].title
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - 32 - 9
        let width = availableWidth / 2
        return CGSize(width: width, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 46)
    }
}
