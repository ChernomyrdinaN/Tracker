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
        didSet {
            updateUIForCurrentState()
        }
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
    
    // MARK: - Private Methods
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
    
    private func setupDelegates() {
        recordStore.delegate = self
        trackerStore.delegate = self
    }
    
    private func loadStatistics() {
        let allRecords = recordStore.fetchRecords()
        let existingTrackers = trackerStore.fetchTrackers()
        let existingTrackerIDs = Set(existingTrackers.map { $0.id })
        
        completedTrackersCount = allRecords.filter { record in
            existingTrackerIDs.contains(record.trackerId)
        }.count
    }
    
    private func updateUIForCurrentState() {
        if completedTrackersCount > 0 {
            emptyStateView.isHidden = true
            completedTrackersCard.isHidden = false
            completedTrackersCard.update(value: "\(completedTrackersCount)")
        } else {
            emptyStateView.isHidden = false
            completedTrackersCard.isHidden = true
        }
    }
    
    // MARK: - Factory Methods
    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = "Статистика"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makeEmptyStateView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .error3)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "Анализировать пока нечего"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = Colors.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(label)
        
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

// MARK: - TrackerStoreDelegate, TrackerRecordStoreDelegate
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

// MARK: - Stat Card View
final class StatCardView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(title: String, value: String) {
        super.init(frame: .zero)
        setupUI()
        configure(title: title, value: value)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = Colors.white
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = Colors.blue.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        
        let subviews = [valueLabel, titleLabel]
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 90),
            
            // Располагаем valueLabel сверху
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            // Располагаем titleLabel под valueLabel с отступом 7 пунктов
            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 7),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12)
        ])
    }
    
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
    
    func update(value: String) {
        valueLabel.text = value
    }
}
