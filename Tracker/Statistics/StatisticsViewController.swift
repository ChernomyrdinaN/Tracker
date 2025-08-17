//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 16.06.2025.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - Properties
    private let recordStore = TrackerRecordStore()
    private let trackerStore = TrackerStore()
    private var completedTrackersCount: Int = 0 {
        didSet { updateUIForCurrentState() }
    }
    
    private lazy var titleLabel = makeTitleLabel()
    private lazy var emptyStateView = makeEmptyStateView()
    private lazy var completedTrackersCard = StatCardView(title: "Трекеров завершено", value: "0")
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegates()
        loadStatistics()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStatistics()
    }
}

// MARK: - UI Setup & Configuration
extension StatisticsViewController {
    private func setupUI() {
        view.backgroundColor = Colors.white
        
        [titleLabel, emptyStateView, completedTrackersCard].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 41),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            completedTrackersCard.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77),
            completedTrackersCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            completedTrackersCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            completedTrackersCard.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func updateUIForCurrentState() {
        let hasCompletedTrackers = completedTrackersCount > 0
        emptyStateView.isHidden = hasCompletedTrackers
        completedTrackersCard.isHidden = !hasCompletedTrackers
        completedTrackersCard.update(value: "\(completedTrackersCount)")
    }
}

// MARK: - Data Management
extension StatisticsViewController {
    private func setupDelegates() {
        recordStore.delegate = self
        trackerStore.delegate = self
    }
    
    private func loadStatistics() {
        let allRecords = recordStore.fetchRecords()
        let existingTrackers = trackerStore.fetchTrackers()
        let existingTrackerIDs = Set(existingTrackers.map { $0.id })
        
        completedTrackersCount = allRecords.filter {
            existingTrackerIDs.contains($0.trackerId)
        }.count
    }
}

// MARK: - Factory Methods
extension StatisticsViewController {
    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = "Статистика"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = Colors.black
        return label
    }
    
    private func makeEmptyStateView() -> UIView {
        let view = UIView()
        let imageView = UIImageView(image: UIImage(resource: .error3))
        let label = UILabel()
        
        imageView.contentMode = .scaleAspectFit
        label.text = "Анализировать пока нечего"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = Colors.black
        label.textAlignment = .center
        
        [imageView, label].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
}

// MARK: - Store Delegates
extension StatisticsViewController: TrackerStoreDelegate, TrackerRecordStoreDelegate {
    func didUpdateTrackers() {
        DispatchQueue.main.async { [weak self] in
            self?.loadStatistics()
        }
    }
    
    func didUpdateRecords() {
        DispatchQueue.main.async { [weak self] in
            self?.loadStatistics()
        }
    }
}
