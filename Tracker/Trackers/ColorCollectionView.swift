//
//  ColorCollectionView.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 04.07.2025.
//

import UIKit

final class ColorCollectionView: UICollectionView {
    var selectedColor: UIColor? {
        didSet {
            reloadData()
            if let selectedColor {
                didSelectColor?(selectedColor)
            }
        }
    }
    var didSelectColor: ((UIColor) -> Void)?
    
    private let identifier = ColorCell.identifier
    
    private enum Layout {
        static let itemsPerRow: CGFloat = 6
        static let itemSize = CGSize(width: 52, height: 52)
        static let sectionInsets = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        static let lineSpacing: CGFloat = 5
    }
    
    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        register(ColorCell.self, forCellWithReuseIdentifier: identifier)
        dataSource = self
        delegate = self
        isScrollEnabled = false
        allowsMultipleSelection = false
    }
    
    private var interitemSpacing: CGFloat {
        let availableWidth = bounds.width - Layout.sectionInsets.left - Layout.sectionInsets.right
        let totalItemsWidth = Layout.itemsPerRow * Layout.itemSize.width
        return (availableWidth - totalItemsWidth) / (Layout.itemsPerRow - 1)
    }
}

extension ColorCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Colors.trackerColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: identifier,
            for: indexPath
        ) as? ColorCell else {
            return UICollectionViewCell()
        }
        
        let color = Colors.trackerColors[indexPath.row]
        cell.configure(with: color, isSelected: color == selectedColor)
        return cell
    }
}

extension ColorCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColor = Colors.trackerColors[indexPath.row]
    }
}

extension ColorCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        Layout.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        Layout.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        interitemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Layout.lineSpacing
    }
}
