//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 21.06.2025.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    // MARK: - UI Elements
    private let mainView = UIView()
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    private let doneButton = UIButton()
    
    // MARK: - Properties
    private let daysOfWeek = WeekDay.allCases
    var selectedDays: Set<WeekDay> = []
    var onScheduleSelected: ((Set<WeekDay>) -> Void)?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = Colors.white
        mainView.backgroundColor = Colors.white
        
        configureTitleLabel()
        configureTableView()
        configureDoneButton()
        
        [mainView, titleLabel, tableView, doneButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func configureTitleLabel() {
        titleLabel.text = "Расписание"
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = Colors.black
        titleLabel.textAlignment = .center
    }
    
    private func configureTableView() {
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = Colors.gray
    }
    
    private func configureDoneButton() {
        doneButton.setTitle("Готово", for: .normal)
        doneButton.backgroundColor = Colors.black
        doneButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        doneButton.setTitleColor(Colors.white, for: .normal)
        doneButton.layer.cornerRadius = 16
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(daysOfWeek.count * 75)),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Actions
    @objc private func doneButtonTapped() {
        onScheduleSelected?(selectedDays)
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ScheduleCell.reuseIdentifier,
            for: indexPath
        ) as? ScheduleCell else {
            return UITableViewCell()
        }
        
        let day = daysOfWeek[indexPath.row]
        cell.configure(with: day, isOn: selectedDays.contains(day))
        
        cell.onSwitchChanged = { [weak self] isOn in
            if isOn {
                self?.selectedDays.insert(day)
            } else {
                self?.selectedDays.remove(day)
            }
        }
        
        if indexPath.row == daysOfWeek.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
