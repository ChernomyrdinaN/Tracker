//
//  CategoryCell.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 18.07.2025.
//

import UIKit

final class CategoryCell: UITableViewCell {
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = Colors.black
        return label
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = Colors.blue
        imageView.isHidden = true
        return imageView
    }()
    
    // MARK: - Properties
    static let reuseIdentifier = "CategoryCell"
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with title: String, isSelected: Bool) {
        titleLabel.text = title
        UIView.animate(withDuration: 0.3) {
            self.checkmarkImageView.isHidden = !isSelected
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        [titleLabel, checkmarkImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            contentView.heightAnchor.constraint(equalToConstant: 75),
        ])
    }
    
    private func setupAppearance() {
        backgroundColor = Colors.background
        contentView.backgroundColor = Colors.background
        selectionStyle = .default
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
}
