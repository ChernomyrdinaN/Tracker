//
//  ColorCollectionView.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 04.07.2025.
//

import UIKit

final class ColorCollectionView: UICollectionView {
    
    // MARK: - Properties
    var selectedColor: UIColor?
    var didSelectColor: ((UIColor) -> Void)?
    
    private let identifier = "ColorCell"
    private let itemsPerRow: CGFloat = 6
    private let sectionInsets = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
    
    // MARK: - Initialization
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        super.init(frame: .zero, collectionViewLayout: layout)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupCollectionView() {
        register(ColorCell.self, forCellWithReuseIdentifier: identifier)
        dataSource = self
        delegate = self
        isScrollEnabled = false
        allowsMultipleSelection = false
        backgroundColor = .clear
    }
}

// MARK: - UICollectionViewDataSource
extension ColorCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        Colors.trackerColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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

// MARK: - UICollectionViewDelegate
extension ColorCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        selectedColor = Colors.trackerColors[indexPath.row]
        didSelectColor?(selectedColor!)
        reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ColorCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.bounds.width
        let itemWidth = (totalWidth - sectionInsets.left - sectionInsets.right) / itemsPerRow
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
