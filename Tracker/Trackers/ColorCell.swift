//
//  ColorCell.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 04.07.2025.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    
    static let identifier = "ColorCell"
    
    private enum Constants {
        static let outerSize: CGFloat = 40
        static let innerSize: CGFloat = 46
        static let cornerRadius: CGFloat = 8
        static let borderWidth: CGFloat = 3
        static let borderAlpha: CGFloat = 0.3
    }
    
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.cornerRadius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let selectionBorderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.borderWidth = Constants.borderWidth
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with color: UIColor, isSelected: Bool) {
        colorView.backgroundColor = color
        selectionBorderView.layer.borderColor = color.withAlphaComponent(Constants.borderAlpha).cgColor
        selectionBorderView.isHidden = !isSelected
        
        if isSelected {
            bringSubviewToFront(selectionBorderView)
        }
    }
    
    private func setupViews() {
        contentView.addSubview(colorView)
        contentView.addSubview(selectionBorderView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: Constants.outerSize),
            colorView.heightAnchor.constraint(equalToConstant: Constants.outerSize),
            
            selectionBorderView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectionBorderView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectionBorderView.widthAnchor.constraint(equalToConstant: Constants.innerSize),
            selectionBorderView.heightAnchor.constraint(equalToConstant: Constants.innerSize)
        ])
    }
}
