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
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "14.12.22" // Пример даты
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchField: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        searchBar.setImage(UIImage(named: "icon"), for: .search, state: .normal)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            textField.textColor = .black
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
        mainView.addSubview(dateLabel)
        mainView.addSubview(addButton)
        mainView.addSubview(titleLabel)
        mainView.addSubview(searchField)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 27.87),
            dateLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16),
            
            addButton.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 27.87),
            addButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            addButton.widthAnchor.constraint(equalToConstant: 24),
            addButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            searchField.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 16),
            searchField.widthAnchor.constraint(equalToConstant: 254),
            searchField.heightAnchor.constraint(equalToConstant: 41)
        ])
    }
    
}
