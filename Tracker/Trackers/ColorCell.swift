//
//  ColorCell.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 04.07.2025.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    static let identifier = "ColorCell"
    
    // MARK: - UI Properties
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let selectionBorderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 3
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    func configure(with color: UIColor, isSelected: Bool) {
        colorView.backgroundColor = color
        selectionBorderView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
        selectionBorderView.isHidden = !isSelected
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        contentView.addSubview(colorView)
        contentView.addSubview(selectionBorderView)
        contentView.clipsToBounds = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 52),
            colorView.heightAnchor.constraint(equalToConstant: 52),
            
            selectionBorderView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectionBorderView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectionBorderView.widthAnchor.constraint(equalToConstant: 46),
            selectionBorderView.heightAnchor.constraint(equalToConstant: 46)
        ])
    }
}
