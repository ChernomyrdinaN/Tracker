//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 14.06.2025.
//

import UIKit

final class TrackersViewController: UIViewController {
    // MARK: - Properties
    private let trackerStore = TrackerStore(context: AppDelegate.viewContext)
    private let categoryStore = TrackerCategoryStore(context: AppDelegate.viewContext)
    private let recordStore = TrackerRecordStore(context: AppDelegate.viewContext)
    
    private let keyboardHandler = KeyboardHandler()
    
    private var isEmptyState = false {
        didSet {
            errorImageView.isHidden = !isEmptyState
            trackLabel.isHidden = !isEmptyState
            collectionView.isHidden = isEmptyState
        }
    }
    
    private var currentDate = Date() {
        didSet {
            collectionView.reloadData()
            isEmptyState = filteredCategories.isEmpty
        }
    }
    
    private var categories: [TrackerCategory] = []
    
    private var completedTrackers: [TrackerRecord] = []
    
    private var filteredCategories: [TrackerCategory] {
        categories.compactMap { category in
            let filtered = category.trackers.filter { isTrackerVisible($0, for: currentDate) }
            return filtered.isEmpty ? nil : TrackerCategory(id: category.id, title: category.title, trackers: filtered)
        }
    }
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = Colors.black
        return label
    }()
    
    private let searchField: UITextField = {
        let field = UITextField()
        field.placeholder = "Поиск"
        field.backgroundColor = Colors.searchFieldBackground
        field.font = .systemFont(ofSize: 17)
        field.textColor = Colors.black
        field.tintColor = Colors.black
        field.layer.cornerRadius = 10
        
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 36))
        
        let icon = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        let iconView = UIImageView(image: icon)
        iconView.tintColor = Colors.gray
        iconView.frame = CGRect(x: 8, y: 10, width: 16, height: 16)
        
        container.addSubview(iconView)
        field.leftView = container
        field.leftViewMode = .always
        
        return field
    }()
    
    private lazy var errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .ilError1)
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private let trackLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = Colors.black
        label.isHidden = true
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TrackerCell.self, forCellWithReuseIdentifier: "TrackerCell")
        collection.register(
            TrackerSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerSectionHeader.reuseIdentifier
        )
        collection.backgroundColor = Colors.white
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(resource: .addTracker),
            style: .plain,
            target: self,
            action: #selector(addButtonTapped)
        )
        button.tintColor = Colors.black
        button.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ru_RU")
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        picker.tintColor = Colors.blue
        return picker
    }()
    
    private lazy var datePickerBarButton: UIBarButtonItem = {
        return UIBarButtonItem(customView: datePicker)
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        view.backgroundColor = Colors.white
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupConstraints()
        setupKeyboardHandler()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isEmptyState = self.filteredCategories.isEmpty
        }
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        [titleLabel, searchField, errorImageView, trackLabel, collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 34),
            
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            
            errorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            trackLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 8),
            trackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = datePickerBarButton
    }
    
    private func setupKeyboardHandler() {
        keyboardHandler.setup(for: self)
        searchField.delegate = keyboardHandler
    }
    
    // MARK: - Helper Methods
    private func isTrackerVisible(_ tracker: Tracker, for date: Date) -> Bool {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        return tracker.schedule.contains { $0.calendarIndex == weekday }
    }
    
    private func isTrackerCompletedToday(_ trackerId: UUID) -> Bool {
        completedTrackers.contains { record in
            record.trackerId == trackerId && Calendar.current.isDate(record.date, inSameDayAs: currentDate)
        }
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        let habitVC = HabitCreationViewController()
        habitVC.modalPresentationStyle = .formSheet
        
        habitVC.onTrackerCreated = { [weak self] newTracker in
            guard let self = self else { return }
            
            self.trackerStore.addTracker(newTracker)
            
            self.loadTrackers()
            self.collectionView.reloadData()
            self.isEmptyState = self.filteredCategories.isEmpty
        }
        
        present(UINavigationController(rootViewController: habitVC), animated: true)
    }
    
    private func loadTrackers() {
        categories = categoryStore.fetchCategories()
        if categories.isEmpty {
            let defaultCategory = TrackerCategory(id: UUID(), title: "Образование", trackers: [])
            categoryStore.addCategory(defaultCategory)
            categories = [defaultCategory]
        }
        completedTrackers = recordStore.fetchRecords()
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "TrackerCell",
            for: indexPath
        ) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
        
        cell.configure(
            with: tracker,
            completedDays: completedTrackers.filter { $0.trackerId == tracker.id }.count,
            isCompletedToday: isTrackerCompletedToday(tracker.id),
            currentDate: currentDate
        )
        
        cell.onPlusButtonTapped = { [weak self] trackerId, date, isCompleted in
            guard let self else { return }
            
            if isCompleted {
                self.completedTrackers.append(TrackerRecord(trackerId: trackerId, date: date))
            } else {
                self.completedTrackers.removeAll { $0.trackerId == trackerId && Calendar.current.isDate($0.date, inSameDayAs: date) }
            }
            collectionView.reloadData()
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 41) / 2, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: section == 0 ? 12 : 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackerSectionHeader.reuseIdentifier,
                for: indexPath
              ) as? TrackerSectionHeader else {
            return UICollectionReusableView()
        }
        
        let category = filteredCategories[indexPath.section]
        header.configure(with: category.title)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 32)
    }
}
