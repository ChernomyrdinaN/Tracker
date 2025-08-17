//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 14.06.2025.
//
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Properties
    private enum Analytics {
        static let screenName = "Main"
        static let addTracker = "add_tracker"
        static let tracker = "tracker"
        static let filter = "filter"
        static let edit = "edit"
        static let delete = "delete"
    }
    
    private let analyticsService = AnalyticsService.shared
    private let trackerStore = TrackerStore()
    private let categoryStore = TrackerCategoryStore()
    private let recordStore = TrackerRecordStore()
    private let keyboardHandler = KeyboardHandler()
    private let settingsService: SettingsServiceProtocol = SettingsService()
    
    private var currentDate = Date() {
        didSet {
            applyFilter()
            updateUIForCurrentState()
        }
    }
    
    private var categories = [TrackerCategory]() {
        didSet { applyFilter() }
    }
    
    private var completedTrackers = [TrackerRecord]() {
        didSet { collectionView.reloadData() }
    }
    
    private var currentFilter: FilterType = .all {
        didSet { applyFilter() }
    }
    
    private var visibleCategories = [TrackerCategory]() {
        didSet {
            collectionView.reloadData()
            updateUIForCurrentState()
        }
    }
    
    private var searchText = "" {
        didSet { applyFilter() }
    }
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var searchTextField = makeSearchTextField()
    private lazy var cancelSearchButton = makeCancelSearchButton()
    private lazy var errorImageView = makeErrorImageView()
    private lazy var trackLabel = makeTrackLabel()
    private lazy var collectionView = makeCollectionView()
    private lazy var addButton = makeAddButton()
    private lazy var datePicker = makeDatePicker()
    private lazy var filterButton = makeFilterButton()
    private lazy var datePickerBarButton = UIBarButtonItem(customView: datePicker)
    
    private var searchFieldTrailingConstraint: NSLayoutConstraint?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupDelegates()
        setupTargetsAndSelectors()
        loadInitialData()
        loadCurrentFilter()
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
            if let firstCategory = self?.categoryStore.fetchAllCategories().first {
                try? self?.trackerStore.addTracker(newTracker, to: firstCategory)
                self?.loadInitialData()
            }
        }
        
        present(UINavigationController(rootViewController: habitVC), animated: true)
    }
    
    @objc private func filterButtonTapped() {
        analyticsService.trackButtonClick(Analytics.screenName, item: Analytics.filter)
        let filterVC = FilterViewController()
        filterVC.selectedFilter = currentFilter
        filterVC.onFilterSelected = { [weak self] filter in
            self?.currentFilter = filter
            
            if filter == .today {
                let today = Calendar.current.startOfDay(for: Date())
                self?.datePicker.date = today
                self?.currentDate = today
            }
            
            self?.saveCurrentFilter()
            self?.dismiss(animated: true)
        }
        
        present(filterVC, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let newDate = sender.date
        guard newDate != currentDate else { return }
        
        if currentFilter == .today {
            currentFilter = .all
            saveCurrentFilter()
        }
        
        currentDate = newDate
    }
    
    @objc private func languageDidChange() {
        titleLabel.text = NSLocalizedString("Trackers", comment: "")
        datePicker.locale = Locale.current
        collectionView.reloadData()
    }
    
    @objc private func searchTextChanged(_ sender: UISearchTextField) {
        searchText = sender.text ?? ""
    }
    
    @objc private func cancelSearch() {
        searchTextField.text = ""
        searchText = ""
        searchTextField.resignFirstResponder()
        hideCancelButton()
    }
    
    // MARK: - Private Methods
    private func setupTargetsAndSelectors() {
        addButton.target = self
        addButton.action = #selector(addButtonTapped)
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(languageDidChange),
            name: NSLocale.currentLocaleDidChangeNotification,
            object: nil
        )
    }
    
    private func setupUI() {
        view.backgroundColor = Colors.white
        
        [titleLabel, searchTextField, cancelSearchButton, errorImageView,
         trackLabel, collectionView, filterButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        let trailingConstraint = searchTextField.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -16
        )
        self.searchFieldTrailingConstraint = trailingConstraint
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 34),
            
            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            trailingConstraint,
            
            cancelSearchButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            cancelSearchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            cancelSearchButton.widthAnchor.constraint(equalToConstant: 83),
            
            errorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            trackLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 8),
            trackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        cancelSearchButton.isHidden = true
        cancelSearchButton.alpha = 0
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = datePickerBarButton
    }
    
    private func setupDelegates() {
        trackerStore.delegate = self
        recordStore.delegate = self
        searchTextField.delegate = self
        keyboardHandler.setup(for: self)
    }
    
    private func loadInitialData() {
        categories = categoryStore.fetchAllCategories()
        completedTrackers = recordStore.fetchRecords()
    }
    
    private func updateUIForCurrentState() {
        let hasAnyTrackers = !trackerStore.fetchTrackers().isEmpty
        let hasTrackersAfterFilter = !visibleCategories.isEmpty
        
        if !hasAnyTrackers {
            errorImageView.isHidden = false
            errorImageView.image = UIImage(resource: .error1)
            trackLabel.isHidden = false
            trackLabel.text = "Что будем отслеживать?"
            collectionView.isHidden = true
            filterButton.isHidden = true
        } else if !hasTrackersAfterFilter {
            errorImageView.isHidden = false
            errorImageView.image = UIImage(resource: .error2)
            trackLabel.isHidden = false
            trackLabel.text = "Ничего не найдено"
            collectionView.isHidden = true
            filterButton.isHidden = false
        } else {
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
        var filtered = categories
        
        let filterDate = currentFilter == .today ? today : currentDate
        
        filtered = filtered.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let isVisible = isTrackerVisible(tracker, for: filterDate)
                
                switch currentFilter {
                case .all:
                    return isVisible
                case .today:
                    return isVisible
                case .completed:
                    return isVisible && completedTrackers.contains { record in
                        record.trackerId == tracker.id &&
                        Calendar.current.isDate(record.date, inSameDayAs: filterDate)
                    }
                case .uncompleted:
                    return isVisible && !completedTrackers.contains { record in
                        record.trackerId == tracker.id &&
                        Calendar.current.isDate(record.date, inSameDayAs: filterDate)
                    }
                }
            }
            return trackers.isEmpty ? nil : TrackerCategory(id: category.id, title: category.title, trackers: trackers)
        }
        
        if !searchText.isEmpty {
            let lowercasedSearchText = searchText.lowercased()
            filtered = filtered.compactMap { category in
                let trackers = category.trackers.filter { $0.name.lowercased().contains(lowercasedSearchText) }
                return trackers.isEmpty ? nil : TrackerCategory(id: category.id, title: category.title, trackers: trackers)
            }
        }
        
        visibleCategories = filtered
    }
    
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
    
    private func hideCancelButton() {
        UIView.animate(withDuration: 0.3) {
            self.searchFieldTrailingConstraint?.constant = -16
            self.cancelSearchButton.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.cancelSearchButton.isHidden = true
        }
    }
    
    // MARK: - Factory Methods
    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = NSLocalizedString("Trackers", comment: "Main screen title")
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = Colors.black
        return label
    }
    
    private func makeSearchTextField() -> UISearchTextField {
        let field = UISearchTextField()
        field.placeholder = "Поиск"
        field.backgroundColor = Colors.searchFieldBackground
        field.font = .systemFont(ofSize: 17)
        field.textColor = Colors.black
        field.tintColor = Colors.blue
        field.layer.cornerRadius = 10
        field.clearButtonMode = .never
        
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
    
    private func makeCancelSearchButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(Colors.blue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(cancelSearch), for: .touchUpInside)
        return button
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "TrackerCell",
            for: indexPath
        ) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.item]
        let category = visibleCategories[indexPath.section]
        
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
        
        header.configure(with: visibleCategories[indexPath.section].title)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 32)
    }
}

// MARK: - UITextFieldDelegate
extension TrackersViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField == searchTextField else { return }
        
        let cancelButtonWidth: CGFloat = 83
        let spacingBetweenFieldAndButton: CGFloat = 5
        let totalOffset = cancelButtonWidth + spacingBetweenFieldAndButton
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.searchFieldTrailingConstraint?.constant = -totalOffset
            self?.cancelSearchButton.isHidden = false
            self?.cancelSearchButton.alpha = 1
            self?.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField == searchTextField else { return }
        
        if searchTextField.text?.isEmpty ?? true {
            hideCancelButton()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - TrackerStoreDelegate, TrackerRecordStoreDelegate
extension TrackersViewController: TrackerStoreDelegate, TrackerRecordStoreDelegate {
    func didUpdateTrackers() {
        DispatchQueue.main.async { [weak self] in
            self?.loadInitialData()
        }
    }
    
    func didUpdateRecords() {
        DispatchQueue.main.async { [weak self] in
            self?.completedTrackers = self?.recordStore.fetchRecords() ?? []
            self?.applyFilter()
        }
    }
}
