//
//  EmojiCell.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 04.07.2025.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    // MARK: - Public Properties
    static let identifier = "EmojiCell"
    
    // MARK: - Private Constants
    private enum Constants {
        static let size: CGFloat = 52
        static let cornerRadius: CGFloat = 16
    }
    
    // MARK: - UI Elements
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(emojiLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        contentView.backgroundColor = isSelected ? Colors.lightGray : .clear
        contentView.layer.cornerRadius = isSelected ? Constants.cornerRadius : 0
        contentView.layer.masksToBounds = isSelected
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: Constants.size),
            emojiLabel.heightAnchor.constraint(equalToConstant: Constants.size)
        ])
    }
}
