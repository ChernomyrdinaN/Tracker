//
//  EmojiCell.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 04.07.2025.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    
    static let identifier = "EmojiCell"
    
    private enum Constants {
        static let size: CGFloat = 52
        static let cornerRadius: CGFloat = 16
    }
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(emojiLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with emoji: String, isSelected: Bool) {
           emojiLabel.text = emoji
    
           contentView.backgroundColor = isSelected ? UIColor.lightGray : .clear
           contentView.layer.cornerRadius = isSelected ? 16 : 0
           contentView.layer.masksToBounds = isSelected
       }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: Constants.size),
            emojiLabel.heightAnchor.constraint(equalToConstant: Constants.size)
        ])
    }
}
