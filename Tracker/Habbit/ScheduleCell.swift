//
//  ScheduleCell.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 24.06.2025.
//

import UIKit

final class ScheduleCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let switchControl = UISwitch()
    
    // MARK: - Properties
    static let reuseIdentifier = "ScheduleCell"
    var onSwitchChanged: ((Bool) -> Void)?
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with day: WeekDay, isOn: Bool) {
        titleLabel.text = day.rawValue
        switchControl.isOn = isOn
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = Colors.background
        selectionStyle = .none
        
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.textColor = Colors.black
        
        switchControl.onTintColor = Colors.blue
        switchControl.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        
        [titleLabel, switchControl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            switchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func switchValueChanged() {
        onSwitchChanged?(switchControl.isOn)
    }
}
