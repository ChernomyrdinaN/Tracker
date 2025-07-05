//
//  EmojiCollectionView.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 04.07.2025.
//

import UIKit

final class EmojiCollectionView: UICollectionView {
    
    // MARK: - Properties
    var selectedEmoji: String?
    var didSelectEmoji: ((String) -> Void)?
    
    private let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶",
        "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    private let itemsPerRow: CGFloat = 6
    private let sectionInsets = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
    private let itemSize: CGSize = CGSize(width: 52, height: 52)
    private let spacing: CGFloat = 5
    
    // MARK: - Initialization
    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupCollectionView() {
        register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
        dataSource = self
        delegate = self
        isScrollEnabled = false
        allowsMultipleSelection = false
        backgroundColor = .clear
    }
}

// MARK: - UICollectionViewDataSource
extension EmojiCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EmojiCell.identifier,
            for: indexPath
        ) as? EmojiCell else {
            return UICollectionViewCell()
        }
        
        let emoji = emojis[indexPath.row]
        cell.configure(with: emoji, isSelected: emoji == selectedEmoji)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension EmojiCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        selectedEmoji = emojis[indexPath.row]
        didSelectEmoji?(selectedEmoji!)
        reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension EmojiCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
