//
//  StatCardView.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 08.08.2025.
//

import UIKit

final class StatCardView: UIView {
    
    // MARK: - UI Elements
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(hex: "#007BFA").cgColor,
            UIColor(hex: "#46E69D").cgColor,
            UIColor(hex: "#FD4C49").cgColor
        ]
        layer.startPoint = CGPoint(x: 1, y: 0.5)
        layer.endPoint = CGPoint(x: 0, y: 0.5)
        layer.mask = shapeLayer
        return layer
    }()
    
    private lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 1
        layer.fillColor = nil
        layer.strokeColor = UIColor.black.cgColor
        return layer
    }()
    
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
        addSubviews()
        setupConstraints()
    }
    
    private func setupGradientBorder() {
        layer.addSublayer(gradientLayer)
    }
    
    private func updateGradientBorder() {
        gradientLayer.frame = bounds
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
        shapeLayer.path = path.cgPath
    }
    
    private func addSubviews() {
        [valueLabel, titleLabel].forEach { addSubview($0) }
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
