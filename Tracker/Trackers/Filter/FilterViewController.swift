//
//  FilterViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 03.08.2025.
//

import UIKit

final class FilterViewController: UIViewController {
    // MARK: - Properties
    var selectedFilter: FilterType = .all
    var onFilterSelected: ((FilterType) -> Void)?
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Фильтры"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = Colors.black
        label.textAlignment = .center
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(FilterCell.self, forCellReuseIdentifier: FilterCell.reuseIdentifier)
        table.isScrollEnabled = false
        table.layer.cornerRadius = 16
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.separatorColor = Colors.gray
        return table
    }()
    
    private let filters = FilterType.allCases
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        setupUI()
        setupConstraints()
        setupTableView()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        [titleLabel, tableView].forEach {
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
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(filters.count * 75))
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FilterCell.reuseIdentifier,
            for: indexPath
        ) as? FilterCell else {
            return UITableViewCell()
        }
        
        let filter = filters[indexPath.row]
        
        let shouldShowCheckmark = (filter == selectedFilter) &&
        (filter != .all) &&
        (filter != .today)
        
        cell.configure(with: filter, isSelected: shouldShowCheckmark)
        
        cell.separatorInset = indexPath.row == filters.count - 1 ?
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude) :
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedFilter = filters[indexPath.row]
        self.selectedFilter = selectedFilter
        onFilterSelected?(selectedFilter)
        UserDefaults.standard.set(selectedFilter.rawValue, forKey: "currentFilter")
        dismiss(animated: true)
    }
}
