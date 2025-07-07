//
//  EmojiCollectionView.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 04.07.2025.
//
import UIKit

final class EmojiCollectionView: UICollectionView {
    
    // MARK: - Properties
    private(set) var selectedEmoji: String?
    var onEmojiSelected: ((String) -> Void)?
    
    private let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶",
        "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private enum Layout {
        static let itemsPerRow: CGFloat = 6
        static let itemSize = CGSize(width: 52, height: 52)
        static let sectionInsets = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        static let spacing: CGFloat = 5
    }
    
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
    
    private var interitemSpacing: CGFloat {
        let availableWidth = bounds.width - Layout.sectionInsets.left - Layout.sectionInsets.right
        let totalItemsWidth = Layout.itemsPerRow * Layout.itemSize.width
        return (availableWidth - totalItemsWidth) / (Layout.itemsPerRow - 1)
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
            assertionFailure("Unable to dequeue EmojiCell")
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
        let selectedEmoji = emojis[indexPath.row]
        self.selectedEmoji = selectedEmoji
        onEmojiSelected?(selectedEmoji)
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension EmojiCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       sizeForItemAt indexPath: IndexPath) -> CGSize {
        Layout.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       insetForSectionAt section: Int) -> UIEdgeInsets {
        Layout.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        interitemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Layout.spacing
    }
}
