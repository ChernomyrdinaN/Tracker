//
//  EmojiCell.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 04.07.2025.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    static let identifier = "EmojiCell"
    
    // MARK: - UI Properties
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        if isSelected {
            backgroundColor = Colors.lightGray
            layer.cornerRadius = 16
            layer.masksToBounds = true
        } else {
            backgroundColor = .clear
            layer.cornerRadius = 0
        }
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        contentView.addSubview(emojiLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 52),
            emojiLabel.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
}
