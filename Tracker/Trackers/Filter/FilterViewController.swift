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
    
    private let filters = FilterType.allCases
    
    // MARK: - UI Elements
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Фильтры"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = Colors.black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(FilterCell.self, forCellReuseIdentifier: FilterCell.reuseIdentifier)
        table.isScrollEnabled = false
        table.layer.cornerRadius = 16
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.separatorColor = Colors.gray
        return table
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupTableView()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = Colors.white
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

// MARK: - UITableViewDataSource
extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FilterCell.reuseIdentifier,
            for: indexPath
        ) as? FilterCell else { return UITableViewCell() }
        
        let filter = filters[indexPath.row]
        let shouldShowCheckmark = (filter == selectedFilter) && (filter != .all) && (filter != .today)
        cell.configure(with: filter, isSelected: shouldShowCheckmark)
        
        cell.separatorInset = indexPath.row == filters.count - 1 ?
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude) :
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedFilter = filters[indexPath.row]
        self.selectedFilter = selectedFilter
        onFilterSelected?(selectedFilter)
        dismiss(animated: true)
    }
}
