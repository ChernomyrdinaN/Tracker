//
//  OnboardingPageViewController .swift
//  Tracker
//
//  Created by Наталья Черномырдина on 25.07.2025.
//

import UIKit

final class OnboardingPageViewController: UIViewController {
    // MARK: - UI Elements
    private let backgroundImageView = UIImageView()
    private let titleLabel = UILabel()
    private let skipButton = UIButton(type: .system)
    
    // MARK: - Init
    init(title: String, imageName: String) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = title
        backgroundImageView.image = UIImage(named: imageName)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        configureViews()
        setupConstraints()
    }
    
    private func configureViews() {
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = Colors.black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        skipButton.setTitle("Вот это технологии!", for: .normal)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        skipButton.setTitleColor(Colors.white, for: .normal)
        skipButton.backgroundColor = .black
        skipButton.layer.cornerRadius = 16
        skipButton.addTarget(self, action: #selector(didTapSkipButton), for: .touchUpInside)
        
        [backgroundImageView, titleLabel, skipButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            skipButton.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -200)
        ])
    }
    
    // MARK: - Actions
    @objc private func didTapSkipButton() {
        NotificationCenter.default.post(name: .onboardingSkipButtonTapped, object: nil)
    }
}
