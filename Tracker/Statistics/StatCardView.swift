//
//  StatCardView.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 08.08.2025.
//

import UIKit

final class StatCardView: UIView {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let gradientLayer = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()
    
    // MARK: - Init
    init(title: String, value: String) {
        super.init(frame: .zero)
        setupUI()
        configure(title: title, value: value)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientBorder()
    }
    
    // MARK: - Configuration
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
    
    func update(value: String) {
        valueLabel.text = value
    }
}

// MARK: - UI Setup
extension StatCardView {
    private func setupUI() {
        backgroundColor = Colors.white
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        setupGradientBorder()
        configureLabels()
        setupConstraints()
    }
    
    private func setupGradientBorder() {
        gradientLayer.colors = [
            UIColor(hex: "#007BFA").cgColor,
            UIColor(hex: "#46E69D").cgColor,
            UIColor(hex: "#FD4C49").cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.mask = shapeLayer
    
        shapeLayer.lineWidth = 1
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        
        layer.addSublayer(gradientLayer)
    }
    
    private func updateGradientBorder() {
        gradientLayer.frame = bounds
        
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
        shapeLayer.path = path.cgPath
    }
    
    private func configureLabels() {
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = Colors.black
        valueLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        valueLabel.textColor = Colors.black
        
        [valueLabel, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 90),
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 7),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12)
        ])
    }
}
