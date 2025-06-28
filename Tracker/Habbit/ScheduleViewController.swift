//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 21.06.2025.
//

import UIKit

final class ScheduleViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = Colors.black
        label.textAlignment = .center
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
        table.isScrollEnabled = false
        table.layer.cornerRadius = 16
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.separatorColor = Colors.gray
        return table
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.backgroundColor = Colors.black
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(Colors.white, for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let daysOfWeek = WeekDay.allCases
    var selectedDays: Set<WeekDay> = []
    var onScheduleSelected: ((Set<WeekDay>) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        setupViews()
        setupConstraints()
        setupTableView()
    }
    
    private func setupViews() {
        [titleLabel, tableView, doneButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
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
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc private func doneButtonTapped() {
        onScheduleSelected?(selectedDays)
        dismiss(animated: true)
    }
}

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        daysOfWeek.count
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
        
        cell.separatorInset = indexPath.row == daysOfWeek.count - 1 ?
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude) :
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}
