//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 16.06.2025.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - UI Elements
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Здесь будет статистика"
        label.textAlignment = .center
        label.textColor = Colors.blackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = Colors.whiteDay
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(mainLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
