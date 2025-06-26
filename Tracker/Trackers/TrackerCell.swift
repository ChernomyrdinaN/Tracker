//
//  TrackerCell.swift
//  Tracker
//
//  Created by Наталья Черномырдина on 24.06.2025.
//

import UIKit

final class TrackerCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let containerView = UIView()
    private let emojiBackground = UIView()
    private let emojiLabel = UILabel()
    private let titleLabel = UILabel()
    private let daysLabel = UILabel()
    private let plusButton = UIButton()
    
    // MARK: - Properties
    static let identifier = "TrackerCell"
    private var trackerId: UUID?
    private var completedDays = 0
    private var currentDate = Date()
    private var isCompletedToday = false
    
    var onPlusButtonTapped: ((UUID, Date, Bool) -> Void)?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupButtonActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with tracker: Tracker, completedDays: Int, isCompletedToday: Bool, currentDate: Date) {
        self.trackerId = tracker.id
        self.completedDays = completedDays
        self.isCompletedToday = isCompletedToday
        self.currentDate = currentDate
        
        containerView.backgroundColor = UIColor(named: tracker.colorAssetName)
        emojiBackground.backgroundColor = Colors.white?.withAlphaComponent(0.3)
        emojiLabel.text = tracker.emoji
        titleLabel.text = tracker.name
        daysLabel.text = formattedDaysCount(completedDays)
        
        updatePlusButton()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        
        emojiBackground.layer.cornerRadius = 12
        emojiBackground.clipsToBounds = true
        
        emojiLabel.font = .systemFont(ofSize: 16)
        emojiLabel.textAlignment = .center
        
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = Colors.white
        titleLabel.numberOfLines = 2
        
        daysLabel.font = .systemFont(ofSize: 12, weight: .medium)
        daysLabel.textColor = Colors.black
        
        plusButton.layer.cornerRadius = 17
        plusButton.clipsToBounds = true
        
        [containerView, daysLabel, plusButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [emojiBackground, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiBackground.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiBackground.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            emojiBackground.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            emojiBackground.widthAnchor.constraint(equalToConstant: 24),
            emojiBackground.heightAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackground.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackground.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            daysLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            plusButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    private func setupButtonActions() {
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    private func updatePlusButton() {
        let imageName = isCompletedToday ? "checkmark" : "plus"
        plusButton.setImage(UIImage(systemName: imageName), for: .normal)
        plusButton.backgroundColor = containerView.backgroundColor
        plusButton.tintColor = Colors.white
        
        let isFutureDate = currentDate > Date()
        plusButton.isEnabled = !isFutureDate
        plusButton.alpha = isFutureDate ? 0.5 : 1.0
    }
    
    private func formattedDaysCount(_ count: Int) -> String {
        let remainder = count % 10
        let remainder100 = count % 100
        
        if remainder100 >= 11 && remainder100 <= 19 {
            return "\(count) дней"
        } else if remainder == 1 {
            return "\(count) день"
        } else if remainder >= 2 && remainder <= 4 {
            return "\(count) дня"
        } else {
            return "\(count) дней"
        }
    }
    
    // MARK: - Actions
    @objc private func plusButtonTapped() {
        guard let trackerId = trackerId else { return }
        
        isCompletedToday.toggle()
        completedDays += isCompletedToday ? 1 : -1
        daysLabel.text = formattedDaysCount(completedDays)
        
        updatePlusButton()
        onPlusButtonTapped?(trackerId, currentDate, isCompletedToday)
    }
}
