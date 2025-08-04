//
//   FilterCell.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 04.08.2025.
//

import UIKit

final class FilterCell: UITableViewCell {
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let checkmarkImageView = UIImageView()
    
    // MARK: - Properties
    static let reuseIdentifier = "FilterCell"
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with filter: FilterType, isSelected: Bool) {
        titleLabel.text = filter.title
        checkmarkImageView.isHidden = !isSelected
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = Colors.background
        selectionStyle = .none
        
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.textColor = Colors.black
        
        checkmarkImageView.image = UIImage(systemName: "checkmark")?
            .withTintColor(Colors.blue, renderingMode: .alwaysOriginal)
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.isHidden = true
        
        [titleLabel, checkmarkImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
