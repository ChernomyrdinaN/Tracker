//
//  CategorySelectionViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 16.07.2025.
//

import UIKit

final class CategorySelectionViewController: UIViewController {
    // MARK: - Properties
    let viewModel = CategoriesViewModel()
    var onCategorySelected: ((TrackerCategory) -> Void)?
    
    // MARK: - UI Elements
    private lazy var titleLabel = makeTitleLabel()
    private lazy var errorImageView = makeErrorImageView()
    private lazy var trackLabel = makeTrackLabel()
    private lazy var addButton = makeAddButton()
    private lazy var tableView = makeTableView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        setupUI()
        setupActions()
        bindViewModel()
        setupTableView()
    }
    
    // MARK: - Private Methods
    private func bindViewModel() {
        viewModel.onCategoriesUpdated = { [weak self] in
            self?.tableView.reloadData()
            self?.updateTableViewHeight()
        }
        
        viewModel.onEmptyStateChanged = { [weak self] isEmpty in
            self?.errorImageView.isHidden = !isEmpty
            self?.trackLabel.isHidden = !isEmpty
            self?.tableView.isHidden = isEmpty
            if !isEmpty {
                self?.updateTableViewHeight()
            }
        }
    }
    
    private func setupUI() {
        [titleLabel, errorImageView, trackLabel, tableView, addButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            errorImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            trackLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 8),
            trackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: addButton.topAnchor, constant: -16),
            
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        updateTableViewHeight()
    }
    
    private func setupTableView() {
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupActions() {
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private func updateTableViewHeight() {
        tableView.constraints.filter { $0.firstAttribute == .height }.forEach {
            tableView.removeConstraint($0)
        }
        let height = min(CGFloat(viewModel.categories.count) * 75, view.bounds.height - 200)
        tableView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    private func showEditAlert(for index: Int) {
        let category = viewModel.categories[index]
        let editVC = EditCategoryViewController(currentName: category.title)
        editVC.onSave = { [weak self] newName in
            self?.viewModel.updateCategory(at: index, newTitle: newName)
        }
        present(UINavigationController(rootViewController: editVC), animated: true)
    }
    
    private func confirmDeletion(at indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "Удалить категорию?",
            message: "Все трекеры в этой категории будут удалены",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteCategory(at: indexPath.row)
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - UI Factory Methods
    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = "Категория"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = Colors.black
        label.textAlignment = .center
        return label
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
        label.text = "Привычки и события\nможно объединить по смыслу"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 2
        label.textColor = Colors.black
        label.textAlignment = .center
        label.isHidden = true
        return label
    }
    
    private func makeAddButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Добавить категорию", for: .normal)
        button.backgroundColor = Colors.black
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(Colors.white, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }
    
    private func makeTableView() -> UITableView {
        let table = UITableView()
        table.isScrollEnabled = true
        table.alwaysBounceVertical = true
        table.layer.cornerRadius = 16
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.tableFooterView = UIView()
        table.separatorColor = Colors.gray
        table.backgroundColor = Colors.background
        return table
    }
    
    // MARK: - Actions
    @objc private func addButtonTapped() {
        let newCategoryVC = NewCategoryViewController()
        newCategoryVC.onCategoryCreated = { [weak self] name in
            self?.viewModel.addCategory(title: name)
        }
        present(UINavigationController(rootViewController: newCategoryVC), animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension CategorySelectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as! CategoryCell
        let category = viewModel.categories[indexPath.row]
        let isSelected = viewModel.getSelectedCategory()?.id == category.id
        cell.configure(with: category.title, isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = viewModel.categories[indexPath.row]
        viewModel.selectCategory(category)
        
        if let cell = tableView.cellForRow(at: indexPath) as? CategoryCell {
            cell.configure(with: category.title, isSelected: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            self?.onCategorySelected?(category)
            self?.dismiss(animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(title: "Редактировать") { [weak self] _ in
                self?.showEditAlert(for: indexPath.row)
            }
            
            let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                self?.confirmDeletion(at: indexPath)
            }
            
            return UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
}
