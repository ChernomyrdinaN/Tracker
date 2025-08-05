//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 14.06.2025.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Nested Types
    private enum Analytics {
        static let screenName = "Main"
        static let addTracker = "add_tracker"
        static let tracker = "tracker"
        static let filter = "filter"
        static let edit = "edit"
        static let delete = "delete"
    }
    
    // MARK: - Services
    private let analyticsService: AnalyticsService = .shared
    private let trackerStore = TrackerStore()
    private let categoryStore = TrackerCategoryStore()
    private let recordStore = TrackerRecordStore()
    private let keyboardHandler = KeyboardHandler()
    private let settingsService: SettingsServiceProtocol = SettingsService()
    
    // MARK: - Properties
    private var currentDate = Date() {
        didSet { updateUIForCurrentState() }
    }
    private var categories: [TrackerCategory] = [] {
        didSet { updateUIForCurrentState() }
    }
    private var completedTrackers: [TrackerRecord] = [] {
        didSet { collectionView.reloadData() }
    }
    private var filteredCategories: [TrackerCategory] = [] {
        didSet { collectionView.reloadData() }
    }
    private var currentFilter: FilterType = .all {
        didSet { applyFilter() }
    }
    
    // MARK: - UI Elements
    private lazy var titleLabel = makeTitleLabel()
    private lazy var searchField = makeSearchField()
    private lazy var errorImageView = makeErrorImageView()
    private lazy var trackLabel = makeTrackLabel()
    private lazy var collectionView = makeCollectionView()
    private lazy var addButton = makeAddButton()
    private lazy var datePicker = makeDatePicker()
    private lazy var filterButton = makeFilterButton()
    private lazy var datePickerBarButton = UIBarButtonItem(customView: datePicker)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupDelegates()
        loadInitialData()
        loadCurrentFilter()
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        analyticsService.trackScreenOpen(Analytics.screenName)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        analyticsService.trackScreenClose(Analytics.screenName)
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        analyticsService.trackButtonClick(Analytics.screenName, item: Analytics.addTracker)
        let habitVC = HabitCreationViewController()
        habitVC.modalPresentationStyle = .formSheet
        
        habitVC.onTrackerCreated = { [weak self] newTracker in
            guard let self = self,
                  let firstCategory = self.categoryStore.fetchAllCategories().first else { return }
            
            try? self.trackerStore.addTracker(newTracker, to: firstCategory)
            self.loadInitialData()
        }
        
        present(UINavigationController(rootViewController: habitVC), animated: true)
    }
    
    @objc private func filterButtonTapped() {
        analyticsService.trackButtonClick(Analytics.screenName, item: Analytics.filter)
        let filterVC = FilterViewController()
        filterVC.selectedFilter = currentFilter
        filterVC.onFilterSelected = { [weak self] filter in
            self?.currentFilter = filter
            self?.saveCurrentFilter()
        }
        present(filterVC, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        if currentFilter == .today {
            currentFilter = .all
        }
        currentDate = sender.date
        applyFilter()
    }
    
    @objc private func languageDidChange() {
        titleLabel.text = NSLocalizedString("Trackers", comment: "")
        datePicker.locale = Locale.current
        collectionView.reloadData()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = Colors.white
        
        [titleLabel, searchField, errorImageView,
         trackLabel, collectionView, filterButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
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
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = datePickerBarButton
    }
    
    private func setupDelegates() {
        trackerStore.delegate = self
        recordStore.delegate = self
        searchField.delegate = keyboardHandler
        keyboardHandler.setup(for: self)
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(languageDidChange),
            name: NSLocale.currentLocaleDidChangeNotification,
            object: nil
        )
    }
    
    // MARK: - Data Management
    private func loadInitialData() {
        categories = categoryStore.fetchAllCategories()
        completedTrackers = recordStore.fetchRecords()
        applyFilter()
    }
    
    private func updateUIForCurrentState() {
        let hasAnyTrackers = !trackerStore.fetchTrackers().isEmpty
        let hasTrackersAfterFilter = !filteredCategories.isEmpty
        
        if !hasAnyTrackers {
            errorImageView.isHidden = false
            errorImageView.image = UIImage(resource: .error1)
            trackLabel.isHidden = false
            trackLabel.text = "Что будем отслеживать?"
            collectionView.isHidden = true
            filterButton.isHidden = true
        }
        else if !hasTrackersAfterFilter {
            errorImageView.isHidden = false
            errorImageView.image = UIImage(resource: .error2)
            trackLabel.isHidden = false
            trackLabel.text = "Ничего не найдено"
            collectionView.isHidden = true
            filterButton.isHidden = false
        }
        else {
            errorImageView.isHidden = true
            trackLabel.isHidden = true
            collectionView.isHidden = false
            filterButton.isHidden = false
        }

        collectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: filterButton.isHidden ? 0 : 70,
            right: 0
        )
    }
    
    private func applyFilter() {
        let today = Calendar.current.startOfDay(for: Date())
        categories = categoryStore.fetchAllCategories()
        completedTrackers = recordStore.fetchRecords()
        
        switch currentFilter {
        case .all:
            filteredCategories = categories.compactMap { category in
                let filtered = category.trackers.filter { isTrackerVisible($0, for: currentDate) }
                return filtered.isEmpty ? nil : TrackerCategory(
                    id: category.id,
                    title: category.title,
                    trackers: filtered
                )
            }
            
        case .today:
            if !Calendar.current.isDate(currentDate, inSameDayAs: today) {
                currentDate = today
                datePicker.setDate(today, animated: true)
            }
            filteredCategories = categories.compactMap { category in
                let filtered = category.trackers.filter { isTrackerVisible($0, for: today) }
                return filtered.isEmpty ? nil : TrackerCategory(
                    id: category.id,
                    title: category.title,
                    trackers: filtered
                )
            }
            
        case .completed:
            filteredCategories = categories.compactMap { category in
                let filtered = category.trackers.filter { tracker in
                    guard isTrackerVisible(tracker, for: currentDate) else { return false }
                    return completedTrackers.contains { record in
                        record.trackerId == tracker.id &&
                        Calendar.current.isDate(record.date, inSameDayAs: currentDate)
                    }
                }
                return filtered.isEmpty ? nil : TrackerCategory(
                    id: category.id,
                    title: category.title,
                    trackers: filtered
                )
            }
            
        case .uncompleted:
            filteredCategories = categories.compactMap { category in
                let filtered = category.trackers.filter { tracker in
                    guard isTrackerVisible(tracker, for: currentDate) else { return false }
                    return !completedTrackers.contains { record in
                        record.trackerId == tracker.id &&
                        Calendar.current.isDate(record.date, inSameDayAs: currentDate)
                    }
                }
                return filtered.isEmpty ? nil : TrackerCategory(
                    id: category.id,
                    title: category.title,
                    trackers: filtered
                )
            }
        }
        
        updateUIForCurrentState()
    }
    
    // MARK: - Helper Methods
    private func isTrackerVisible(_ tracker: Tracker, for date: Date) -> Bool {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        return tracker.schedule.contains { $0.calendarIndex == weekday }
    }
    
    private func isTrackerCompletedToday(_ trackerId: UUID) -> Bool {
        completedTrackers.contains { record in
            record.trackerId == trackerId &&
            Calendar.current.isDate(record.date, inSameDayAs: currentDate)
        }
    }
    
    private func saveCurrentFilter() {
        UserDefaults.standard.set(currentFilter.rawValue, forKey: "currentFilter")
    }
    
    private func loadCurrentFilter() {
        let rawValue = UserDefaults.standard.integer(forKey: "currentFilter")
        currentFilter = FilterType(rawValue: rawValue) ?? .all
    }
    
    // MARK: - Alert Methods
    private func showDeleteConfirmation(for trackerId: UUID) {
        analyticsService.trackButtonClick(Analytics.screenName, item: Analytics.delete)
        guard let tracker = trackerStore.fetchTrackers().first(where: { $0.id == trackerId }) else { return }
        
        let alert = UIAlertController(
            title: "Уверены что хотите удалить трекер?",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            do {
                try self?.trackerStore.deleteTracker(tracker)
                self?.loadInitialData()
            } catch {
                self?.showError(message: "Не удалось удалить трекер")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        present(alert, animated: true)
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Navigation Methods
    private func showEditScreen(for tracker: Tracker, category: TrackerCategory) {
        analyticsService.trackButtonClick(Analytics.screenName, item: Analytics.edit)
        let editVC = EditHabitViewController(
            tracker: tracker,
            category: category,
            trackerStore: trackerStore
        )
        
        editVC.onTrackerCreated = { [weak self] updatedTracker in
            do {
                try self?.trackerStore.updateTracker(updatedTracker, in: category)
            } catch {
                self?.showError(message: "Не удалось обновить трекер")
            }
        }
        
        let navVC = UINavigationController(rootViewController: editVC)
        present(navVC, animated: true)
    }
    
    // MARK: - Factory Methods
    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = NSLocalizedString("Trackers", comment: "Main screen title")
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = Colors.black
        return label
    }
    
    private func makeSearchField() -> UITextField {
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
    }
    
    private func makeErrorImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .error1)
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }
    
    private func makeTrackLabel() -> UILabel {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = Colors.black
        label.isHidden = true
        return label
    }
    
    private func makeCollectionView() -> UICollectionView {
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
    }
    
    private func makeAddButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(
            image: UIImage(resource: .addTracker),
            style: .plain,
            target: self,
            action: #selector(addButtonTapped)
        )
        button.tintColor = Colors.black
        button.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        return button
    }
    
    private func makeDatePicker() -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ru_RU")
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        picker.tintColor = Colors.blue
        return picker
    }
    
    private func makeFilterButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Filters", comment: "Filter button title"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(Colors.white, for: .normal)
        button.backgroundColor = Colors.blue
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
            return UICollectionViewCell()
        }
        
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.item]
        let category = filteredCategories[indexPath.section]
        
        cell.configure(
            with: tracker,
            completedDays: completedTrackers.filter { $0.trackerId == tracker.id }.count,
            isCompletedToday: isTrackerCompletedToday(tracker.id),
            currentDate: currentDate
        )
        
        cell.onPlusButtonTapped = { [weak self] trackerId, date, isCompleted in
            self?.analyticsService.trackButtonClick(Analytics.screenName, item: Analytics.tracker)
            self?.recordStore.toggleRecord(for: trackerId, date: date)
        }
        
        cell.onDeleteTapped = { [weak self] trackerId in
            self?.showDeleteConfirmation(for: trackerId)
        }
        
        cell.onEditTapped = { [weak self] trackerId in
            guard let tracker = self?.trackerStore.fetchTrackers().first(where: { $0.id == trackerId }) else { return }
            self?.showEditScreen(for: tracker, category: category)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.bounds.width - 41) / 2, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: section == 0 ? 12 : 16, left: 16, bottom: 16, right: 16)
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
        
        header.configure(with: filteredCategories[indexPath.section].title)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 32)
    }
}

// MARK: - TrackerStoreDelegate & TrackerRecordStoreDelegate
extension TrackersViewController: TrackerStoreDelegate, TrackerRecordStoreDelegate {
    func didUpdateTrackers() {
        DispatchQueue.main.async { [weak self] in
            self?.loadInitialData()
            self?.applyFilter()
        }
    }
    
    func didUpdateRecords() {
        DispatchQueue.main.async { [weak self] in
            self?.completedTrackers = self?.recordStore.fetchRecords() ?? []
            self?.applyFilter()
        }
    }
}
