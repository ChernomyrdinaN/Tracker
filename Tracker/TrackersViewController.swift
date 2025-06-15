//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 14.06.2025.
//

import UIKit

class TrackersViewController: UIViewController {
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.whiteNight
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addtracker"), for: .normal)
        button.tintColor = Colors.blackNight
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dateButton: UIButton = {
        let button = UIButton()
        button.setTitle("14.12.22", for: .normal) // DateFormatter
        button.titleLabel?.font  = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(Colors.blackDay, for: .normal)
        button.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1) // #F0F0F0 уточнить
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = Colors.blackNight
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchField: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        // Установка иконки лупы
        searchBar.setImage(UIImage(named: "mangnifyingglass"), for: .search, state: .normal)
        
        // Настройка текстового поля
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            // Основные настройки
            textField.backgroundColor = UIColor(named: "#7676803D") // #7676803D из Assets
            textField.textColor = UIColor(named: "#EBEBF5") // #EBEBF5 из Assets
            textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            textField.layer.cornerRadius = 10
            textField.clipsToBounds = true
            
            // Настройка placeholder
            textField.attributedPlaceholder = NSAttributedString(
                string: "Поиск",
                attributes: [
                    .foregroundColor: UIColor(named: "#EBEBF5") ?? .gray, // #EBEBF5 из Assets
                    .font: UIFont.systemFont(ofSize: 17, weight: .regular)
                ]
            )
        }
        
        return searchBar

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(mainView)
        mainView.addSubview(dateButton)
        mainView.addSubview(addButton)
        mainView.addSubview(titleLabel)
        mainView.addSubview(searchField)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6), // сделан
            addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            addButton.widthAnchor.constraint(equalToConstant: 42),
            addButton.heightAnchor.constraint(equalToConstant: 42),
            
            dateButton.centerYAnchor.constraint(equalTo: addButton.centerYAnchor), // сделан
            dateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dateButton.widthAnchor.constraint(equalToConstant: 77),
            dateButton.heightAnchor.constraint(equalToConstant: 34),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16), // сделан
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            titleLabel.widthAnchor.constraint(equalToConstant: 254),
            titleLabel.heightAnchor.constraint(equalToConstant: 41),
            
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16), // сделан
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
}
