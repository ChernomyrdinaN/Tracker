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
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(TrackerCell.self, forCellWithReuseIdentifier: "TrackerCell")
        return collection
    }()
    
    // MARK: - Properties
    private var isEmptyState = false {
        didSet {
            errorImageView.isHidden = !isEmptyState
            trackLabel.isHidden = !isEmptyState
        }
    }
    
    private var currentDate = Date() {
        didSet {
            collectionView.reloadData()
            checkForEmptyState()
        }
    }
    
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupNavigationBar()
        setupDefaultData()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = Colors.white
        configureTitleLabel()
        configureSearchField()
        configureEmptyState()
        addSubviewsAndSetupConstraints()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 167, height: 148)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 9
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(
            image: UIImage(named: "add_tracker")?.withRenderingMode(.alwaysTemplate),
            style: .plain,
            target: self,
            action: #selector(addButtonTapped))
        addButton.tintColor = Colors.black
        navigationItem.leftBarButtonItem = addButton
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    // MARK: - Private Methods
    private func configureTitleLabel() {
        titleLabel.text = "Трекеры"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = Colors.black
    }
    
    private func configureSearchField() {
        searchField.backgroundColor = Colors.searchFieldBackground
        searchField.font = .systemFont(ofSize: 17, weight: .regular)
        searchField.textColor = Colors.searchTextColor
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
    
    private func setupDefaultData() {
        let defaultTracker = Tracker(
            id: UUID(),
            name: "Поливать растения",
            color: "Color selection 5",
            emoji: "🌱",
            schedule: [.monday, .wednesday, .friday],
            isRegular: true,
            colorAssetName: "Color selection 5"
        )
        
        let defaultCategory = TrackerCategory(
            id: UUID(),
            title: "Домашний уют",
            trackers: [defaultTracker]
        )
        
        categories = [defaultCategory]
        checkForEmptyState()
    }
    
    private func checkForEmptyState() {
        let hasVisibleTrackers = categories.contains { category in
            category.trackers.contains { isTrackerVisible($0, for: currentDate) }
        }
        isEmptyState = !hasVisibleTrackers
    }
    
    private func isTrackerVisible(_ tracker: Tracker, for date: Date) -> Bool {
        guard tracker.isRegular else { return true }
        
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        
        return tracker.schedule?.contains { day in
            day.calendarIndex == weekday
        } ?? false
    }
    
    private func isTrackerCompletedToday(_ trackerId: UUID) -> Bool {
        return completedTrackers.contains { record in
            record.trackerId == trackerId && Calendar.current.isDate(record.date, inSameDayAs: currentDate)
        }
    }
    
    private func handleTrackerCompletion(trackerId: UUID, date: Date, isCompleted: Bool) {
        if isCompleted {
            let record = TrackerRecord(trackerId: trackerId, date: date)
            completedTrackers.append(record)
        } else {
            completedTrackers.removeAll { $0.trackerId == trackerId && Calendar.current.isDate($0.date, inSameDayAs: date) }
        }
        collectionView.reloadData()
    }
    
    private func addSubviewsAndSetupConstraints() {
        [errorImageView, trackLabel, titleLabel, searchField, collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
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
            trackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        let habitVC = HabitCreationViewController()
        
        habitVC.onTrackerCreated = { [weak self] newTracker in
            guard let self = self else { return }
            
            if self.categories.isEmpty {
                let newCategory = TrackerCategory(
                    id: UUID(),
                    title: "Новая категория",
                    trackers: [newTracker]
                )
                self.categories.append(newCategory)
            } else {
                self.categories[0].trackers.append(newTracker)
            }
            
            self.collectionView.reloadData()
            self.checkForEmptyState()
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
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "TrackerCell",
            for: indexPath
        ) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let tracker = categories[indexPath.section].trackers[indexPath.item]
        let shouldShow = isTrackerVisible(tracker, for: currentDate)
        cell.isHidden = !shouldShow && tracker.isRegular
        
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
}

// MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: \(categories[indexPath.section].trackers[indexPath.item].name)")
    }
}
