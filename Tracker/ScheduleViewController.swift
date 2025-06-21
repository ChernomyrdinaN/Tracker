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
    
    private let daysOfWeek = WeekDay.allCases
    private var selectedDays: Set<WeekDay> = []
    
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
        
        // Настройка заголовка
        titleLabel.text = "Расписание"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = Colors.black
        titleLabel.textAlignment = .center
        
        // Настройка таблицы
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        // Настройка кнопки "Готово"
        doneButton.setTitle("Готово", for: .normal)
        doneButton.backgroundColor = Colors.black
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        doneButton.setTitleColor(Colors.white, for: .normal)
        doneButton.layer.cornerRadius = 16
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        [mainView, titleLabel, tableView, doneButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Основное вью
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Заголовок
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Таблица
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(daysOfWeek.count * 75)),
            
            // Кнопка "Готово"
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Actions
    @objc private func doneButtonTapped() {
        // Здесь можно передать выбранные дни обратно в предыдущий контроллер
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let day = daysOfWeek[indexPath.row]
        cell.textLabel?.text = day.rawValue
        cell.backgroundColor = Colors.background
        
        // Добавляем переключатель
        let switchView = UISwitch()
        switchView.onTintColor = Colors.blue
        switchView.isOn = selectedDays.contains(day)
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        let day = daysOfWeek[sender.tag]
        if sender.isOn {
            selectedDays.insert(day)
        } else {
            selectedDays.remove(day)
        }
    }
}
