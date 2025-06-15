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
        button.setImage(UIImage(named: "add_tracker"), for: .normal)
        button.tintColor = Colors.blackNight
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dateButton: UIButton = {
        let button = UIButton()
        button.setTitle("14.12.22", for: .normal) // DateFormatter
        button.titleLabel?.font  = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(Colors.blackDay, for: .normal)
        button.backgroundColor = Colors.datePickerBackground // #F0F0F0
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
    
    private lazy var searchField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = Colors.searchFieldBackground
        textField.textColor = Colors.searchTextColor
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        
        // Добавляем иконку лупы
        let iconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconView.tintColor = Colors.searchTextColor
        textField.leftView = iconView
        textField.leftViewMode = .always
        
        // Placeholder
        textField.attributedPlaceholder = NSAttributedString(
            string: "Поиск",
            attributes: [
                .foregroundColor: Colors.searchTextColor ?? .lightGray,
                .font: UIFont.systemFont(ofSize: 17, weight: .regular)
            ]
        )
        
        return textField
    }()
    
    private lazy var errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ilerror1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var trackLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = Colors.blackNight
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        mainView.addSubview(errorImageView)
        mainView.addSubview(trackLabel)
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
            
            errorImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 402),
            errorImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 147),
            errorImageView.widthAnchor.constraint(equalToConstant: 80),
            errorImageView.heightAnchor.constraint(equalToConstant: 80),
            
            trackLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 490),
            trackLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackLabel.widthAnchor.constraint(equalToConstant: 343),
            trackLabel.heightAnchor.constraint(equalToConstant: 18)
            
        ])
    }
}
