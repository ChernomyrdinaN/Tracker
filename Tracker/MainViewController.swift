//
//  MainViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 02.08.2025.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let analyticsService: AnalyticsServiceProtocol
    
    init(analyticsService: AnalyticsServiceProtocol = AnalyticsService.shared) {
        self.analyticsService = analyticsService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        analyticsService.trackScreenOpen("Main")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        analyticsService.trackScreenClose("Main")
    }
    
    // MARK: - UI Actions
    
    @objc private func addTrackButtonTapped() {
        analyticsService.trackButtonClick("Main", item: "add_tracker")
    }
    
    @objc private func trackButtonTapped() {
        analyticsService.trackButtonClick("Main", item: "tracker")
    }
    
    @objc private func filterButtonTapped() {
        analyticsService.trackButtonClick("Main", item: "filter")
    }
    
    private func showContextMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Редактировать", style: .default) { [weak self] _ in
            self?.analyticsService.trackButtonClick("Main", item: "edit")
        })
        
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.analyticsService.trackButtonClick("Main", item: "delete")
            // Логика удаления
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
    }
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let addTrackButton = UIButton(type: .system)
        addTrackButton.setTitle("Добавить трекер", for: .normal)
        addTrackButton.addTarget(self, action: #selector(addTrackButtonTapped), for: .touchUpInside)
        addTrackButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addTrackButton)
        
        let trackButton = UIButton(type: .system)
        trackButton.setTitle("Трекер", for: .normal)
        trackButton.addTarget(self, action: #selector(trackButtonTapped), for: .touchUpInside)
        trackButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackButton)
        
        let filterButton = UIButton(type: .system)
        filterButton.setTitle("Фильтр", for: .normal)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            addTrackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addTrackButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            
            trackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackButton.topAnchor.constraint(equalTo: addTrackButton.bottomAnchor, constant: 20),
            
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.topAnchor.constraint(equalTo: trackButton.bottomAnchor, constant: 20)
        ])
    }
}
